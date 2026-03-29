# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# --- Reseau : VPC dedie ---

resource "google_compute_network" "nemoclaw" {
  name                    = "nemoclaw-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "nemoclaw" {
  name          = "nemoclaw-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.nemoclaw.id

  private_ip_google_access = true
}

# --- Firewall : deny-all + exceptions minimales ---

resource "google_compute_firewall" "deny_all_ingress" {
  name    = "nemoclaw-deny-all-ingress"
  network = google_compute_network.nemoclaw.name

  priority  = 65534
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_tailscale" {
  name    = "nemoclaw-allow-tailscale"
  network = google_compute_network.nemoclaw.name

  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "udp"
    ports    = ["41641"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nemoclaw"]
}

resource "google_compute_firewall" "allow_ssh_tailscale" {
  name    = "nemoclaw-allow-ssh-tailscale"
  network = google_compute_network.nemoclaw.name

  priority  = 1001
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [tostring(var.ssh_port)]
  }

  # CIDR Tailscale (CGNAT)
  source_ranges = ["100.64.0.0/10"]
  target_tags   = ["nemoclaw"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "nemoclaw-allow-internal"
  network = google_compute_network.nemoclaw.name

  priority  = 1002
  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.1.0/24"]
  target_tags   = ["nemoclaw"]
}

# --- Cloud NAT : permet a la VM sans IP publique d'acceder a Internet en sortie ---

resource "google_compute_router" "nemoclaw" {
  name    = "nemoclaw-router"
  region  = var.region
  network = google_compute_network.nemoclaw.id
}

resource "google_compute_router_nat" "nemoclaw" {
  name                               = "nemoclaw-nat"
  router                             = google_compute_router.nemoclaw.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# --- VM GPU ---

resource "google_compute_instance" "nemoclaw" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["nemoclaw"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_size_gb
      type  = "pd-ssd"
    }
  }

  guest_accelerator {
    type  = var.gpu_type
    count = var.gpu_count
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
    automatic_restart   = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.nemoclaw.id
    # Pas d'access_config = pas d'IP publique.
    # Acces uniquement via Tailscale.
  }

  metadata = {
    ssh-keys           = "${var.admin_user}:${var.ssh_public_key}"
    tailscale-auth-key = var.tailscale_auth_key
    ssh-port           = tostring(var.ssh_port)
    admin-user         = var.admin_user
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}
