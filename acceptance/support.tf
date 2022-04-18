# local vars for dry
locals {
  formats = toset(["ini", "yaml", "json"])

  instances_var = [
    {
      name = "localhost"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local" }
    },
    {
      name = "also_localhost"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local", "foo" = "bar" }
    }
  ]

  # mock aws instances
  instances_aws = {
    "one" = {
      id         = "i-1234567890"
      tags       = { "Name" = "one", "foo" = "bar", "ansible_connection" = "local" }
      private_ip = "127.0.0.1"
    },
    "two" = {
      id         = "i-0987654321"
      tags       = { "ansible_connection" = "local" }
      private_ip = "127.0.0.1"
    },
  }
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
