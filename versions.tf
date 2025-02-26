terraform {
  required_version = "~> 1.8"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    stdlib = {
      source  = "mschuchard/stdlib"
      version = "~> 2.0"
    }
  }
}
