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
  description = "Zone GCP (doit supporter le type de GPU choisi)"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Type de machine GCP avec GPU"
  type        = string
  default     = "a2-highgpu-1g"
}

variable "gpu_type" {
  description = "Type de GPU NVIDIA"
  type        = string
  default     = "nvidia-tesla-a100"
}

variable "gpu_count" {
  description = "Nombre de GPU"
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Taille du disque de boot en GB"
  type        = number
  default     = 200
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
  default     = "nemoclaw-enterprise"
}
