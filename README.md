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

The module creates the inventory files at the location `path.root/<prefix>inventory.<format>`. It also assigns the inventory content to the respective `<format>` module output.

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
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix to prepend to the name of the output inventory files. For example: the INI inventory will be named <prefix>inventory.ini. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ini"></a> [ini](#output\_ini) | The Ansible INI format inventory content. |
| <a name="output_json"></a> [json](#output\_json) | The Ansible JSON format inventory content. |
| <a name="output_yaml"></a> [yaml](#output\_yaml) | The Ansible YAML format inventory content. |