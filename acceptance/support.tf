# local vars for dry
locals {
  formats = toset(["ini", "yaml", "json"])
}

# null provider specification
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
