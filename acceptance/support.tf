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
    }
  }

  # mock gcp instances
  instances_gcp = {
    "gcp_one" = {
      name              = "gcp_one"
      tags              = ["Name=gcp_one", "foo=bar", "ansible_connection=local", "othertag", "not-host-var"]
      network_interface = [{ network_ip = "127.0.0.1" }]
    },
    "gcp_two" = {
      name              = "gcp_two"
      tags              = ["ansible_connection=local"]
      network_interface = [{ network_ip = "127.0.0.1" }]
    }
  }

  # mock azure instances
  instances_azr = {
    "azr_one" = {
      id                 = "1234567890abcdefg"
      tags               = { "Name" = "azr_one", "foo" = "bar", "ansible_connection" = "local" }
      private_ip_address = "127.0.0.1"
    },
    "azr_two" = {
      id                 = "gfedcba0987654321"
      tags               = { "ansible_connection" = "local" }
      private_ip_address = "127.0.0.1"
    }
  }

  # mock vsphere instances
  instances_vsp = {
    "vsp_one" = {
      name               = "vsp_one"
      default_ip_address = "127.0.0.1"
      vapp               = [{ "properties" = { "foo" = "bar", "ansible_connection" = "local" } }]
    },
    "vsp_two" = {
      name               = "vsp_two"
      default_ip_address = "127.0.0.1"
      vapp               = [{ "properties" = { "ansible_connection" = "local" } }]
    }
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
