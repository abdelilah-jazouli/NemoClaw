# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

output "instance_name" {
  description = "Nom de l'instance"
  value       = google_compute_instance.nemoclaw.name
}

output "instance_zone" {
  description = "Zone de l'instance"
  value       = google_compute_instance.nemoclaw.zone
}

output "internal_ip" {
  description = "Adresse IP interne (VPC)"
  value       = google_compute_instance.nemoclaw.network_interface[0].network_ip
}

output "tailscale_ssh_command" {
  description = "Commande SSH via Tailscale"
  value       = "ssh -p ${var.ssh_port} ${var.admin_user}@<tailscale-ip>"
}

output "gcloud_serial_console" {
  description = "Commande pour voir les logs de demarrage"
  value       = "gcloud compute instances get-serial-port-output ${google_compute_instance.nemoclaw.name} --zone=${var.zone}"
}
