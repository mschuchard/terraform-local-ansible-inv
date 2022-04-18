# local vars for dry
locals {
  formats = toset(["ini", "yaml", "json"])

  instances_var = [
    {
      name = "var_one"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local" }
    },
    {
      name = "var_two"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local", "foo" = "bar" }
    }
  ]

  # mock aws instances
  instances_aws = {
    "aws_one" = {
      id         = "i-1234567890"
      tags       = { "Name" = "aws_one", "foo" = "bar", "ansible_connection" = "local" }
      private_ip = "127.0.0.1"
    },
    "aws_two" = {
      id         = "i-0987654321"
      tags       = { "ansible_connection" = "local" }
      private_ip = "127.0.0.1"
    },
  }

  # mock gcp instances
  instances_gcp = {
    "gcp_one" = {
      instance_id       = "abcdefg1234567890"
      tags              = ["Name=gcp_one", "foo=bar", "ansible_connection=local", "othertag", "not-host-var"]
      network_interface = [{ network_ip = "127.0.0.1" }]
    },
    "gcp_two" = {
      instance_id       = "0987654321gfedcba"
      tags              = ["ansible_connection=local"]
      network_interface = [{ network_ip = "127.0.0.1" }]
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
