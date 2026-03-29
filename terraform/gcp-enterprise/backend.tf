# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Backend GCS pour stocker l'etat Terraform de maniere partagee et securisee.
#
# Le bloc backend ne supporte pas les variables Terraform.
# Initialisez avec :
#   terraform init -backend-config="bucket=VOTRE-BUCKET-GCS" -backend-config="prefix=nemoclaw/enterprise"
#
# Creez le bucket au prealable :
#   gcloud storage buckets create gs://VOTRE-BUCKET-GCS --location=us-central1 --uniform-bucket-level-access

terraform {
  backend "gcs" {}
}
