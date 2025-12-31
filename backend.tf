terraform {
  required_version = "~>1"

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~>1"
    }
    infisical = {
      source  = "Infisical/infisical"
      version = "~>0.15"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~>5"
    }
  }

  backend "gcs" {
    bucket = "my-projects-306716-terraform-backend"
    prefix = "srv-pg"
  }
}
