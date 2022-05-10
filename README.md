# terraform-local-ansible-inv

`terraform-local-ansible-inv` is a Terraform module for converting objects representing instances and their attributes into dynamically configured Ansible inventories suitable for ingestion by Ansible. In an immutable infrastructure pipeline, the infrastructure provisioning performed by Terraform is typically followed by per-instance customization by Ansible from the standardized image artifact created by Packer. This module facilitates a brokering of information between Terraform and Ansible in that process.

## Usage
Typically you would want to map the Terraform outputs and/or exported attributes to input arguments in the module declarations. This will enable automatic inventory generation based on the changing state of your infrastructure.

```terraform
# example declaration
module "ansible_inv" {
  source = "mschuchard/ansible-inv/local"

  formats   = ["yaml"]
  instances = [
    {
      name = "localhost"
      ip   = "127.0.0.1"
      vars = { "ansible_connection" = "local", "foo" = "bar" }
    }
  ]
}
```

The module creates the inventory files at the location `${path.root}/<prefix>inventory.<format>`. It also assigns the inventory content to the respective `<format>` module output.

This module also supports direct mapping of provider-specific resource objects to module arguments. For example: the following config would automatically create a single inventory with your custom defined instances, and your platform provider instances.

```terraform
resource "aws_instance" "this" {
  for_each = var.my_instances_aws
  ...
}

resource "google_compute_instance" "this" {
  for_each = var.my_instances_gcp
  ...
}

resource "azurerm_linux_virtual_machine" " this" {
  for_each = var.my_instances_azr
  ...
}

resource "vsphere_virtual_machine" "this" {
  for_each = var.my_instances_vsp
  ...
}

module "ansible_inv" {
  source = "mschuchard/ansible-inv/local"

  formats       = ["json"]
  instances     = local.instances
  instances_aws = aws_instance.this
  instances_gcp = google_compute_instance.this
  instances_azr = azurerm_linux_virtual_machine.this
  instances_vsp = vsphere_virtual_machine.this
}
```

Note also that correspondingly named groups will automatically be created for each platform as children of the `all` group, andthe groups will also contain all of the specified instances as hosts. For example, all of the AWS instances will automatically be placed in a child `aws` group within the `all` group.

### AWS

In this situation the `ansible_host` will be set to the instance private IP address. The host entry key will be set to the `Name` tag, and will default to the instance id otherwise. The instance tags will also propagate as key value pairs for the host variables.

### GCP

The `ansible_host` will be set to the instance private IP address as determined by the `network_config` attribute. The host entry key will be set to the `name` argument.

The tags will propagate as key value pairs for the host variables. This is determined by the existence of exactly two groups of characters in each tag that match the pattern `[-\w]+`. If these exist in the tag, then it will be converted to a host variable key value pair. Otherwise, the tag will be ignored. Example of converted tags include:

```
name=myhost
ansible_connection winrm
foo:bar
```

### Azure

In this situation the `ansible_host` will be set to the instance primary private IP address. The host entry key will be set to the `name` argument, and will default to the instance id otherwise. The `ansible_become_user` will be set to the `username` of the `admin_ssh_key` block if it exists; otherwise it will be set to the `admin_username` argument. The instance tags will also propagate as key value pairs for the host variables.

### VSphere

The `ansible_host` will be set to the `default_ip_address` attribute (the primary reachable IP address as determined by VSphere). The host entry will be set to the `name` argument. The `ansible_become_user` will be set to the `full_name` of the `windows_options` block of the `customize` block of the `clone` block if it exists. The `properties` map from `vapp` will propagate as key value pairs for the host variables.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.ansible_inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_formats"></a> [formats](#input\_formats) | The list of formats to output the Ansible inventory. Supported formats are: 'ini', 'yaml', and 'json'. | `set(string)` | `[]` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | The instances and their attributes to populate the Ansible inventory file. | <pre>set(object({<br>    name = string<br>    ip   = string<br>    vars = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_instances_aws"></a> [instances\_aws](#input\_instances\_aws) | The 'aws\_instance.this' map of objects comprising multiple instances to populate the Ansible inventory file. | `map(any)` | `{}` | no |
| <a name="input_instances_azr"></a> [instances\_azr](#input\_instances\_azr) | The 'azurerm\_linux\|windows\_virtual\_machine.this' map of objects comprising multiple instances to populate the Ansible inventory file. | `map(any)` | `{}` | no |
| <a name="input_instances_gcp"></a> [instances\_gcp](#input\_instances\_gcp) | The 'google\_compute\_instance.this' map of objects comprising multiple instances to populate the Ansible inventory file. | `map(any)` | `{}` | no |
| <a name="input_instances_vsp"></a> [instances\_vsp](#input\_instances\_vsp) | The 'vsphere\_virtual\_machine.this' map of objects comprising multiple instances to populate the Ansible inventory file. | `map(any)` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix to prepend to the name of the output inventory files. For example: the INI inventory will be named <prefix>inventory.ini. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ini"></a> [ini](#output\_ini) | The Ansible INI format inventory content. |
| <a name="output_json"></a> [json](#output\_json) | The Ansible JSON format inventory content. |
| <a name="output_yaml"></a> [yaml](#output\_yaml) | The Ansible YAML format inventory content. |
