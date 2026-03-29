# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

variable "project_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "region" {
  description = "Region GCP"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone GCP"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Type de machine GCP (CPU, minimum 4 vCPU / 16 GB)"
  type        = string
  default     = "e2-standard-4"
}

variable "disk_size_gb" {
  description = "Taille du disque de boot en GB"
  type        = number
  default     = 50
}

variable "ssh_port" {
  description = "Port SSH personnalise"
  type        = number
  default     = 2222
}

variable "tailscale_auth_key" {
  description = "Cle d'authentification Tailscale (ephemere recommandee)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Cle publique SSH ED25519 de l'administrateur"
  type        = string
}

variable "admin_user" {
  description = "Nom de l'utilisateur administrateur (sudo)"
  type        = string
  default     = "nemoclaw-admin"
}

variable "instance_name" {
  description = "Nom de l'instance GCP"
  type        = string
  default     = "nemoclaw-personal"
}
