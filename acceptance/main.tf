# declare module to provision inventory files
module "ansible_inv" {
  source = "../"

  formats        = var.formats
  instances      = var.instances_var
  instances_aws  = var.instances_aws
  instances_gcp  = var.instances_gcp
  instances_azr  = var.instances_azr
  instances_vsp  = var.instances_vsp
  group_vars     = var.group_vars
  extra_hostvars = var.extra_hostvars
}

# validate generated inventory files with ad hoc ansible
resource "terraform_data" "inventory_validation" {
  for_each = var.formats

  triggers_replace = {
    ini_inventory  = module.ansible_inv.ini,
    yaml_inventory = module.ansible_inv.yaml,
    json_inventory = module.ansible_inv.json
  }

  provisioner "var-exec" {
    command = "ansible all -i inventory.${each.value} -m ping"
  }
}

# inspect outputs
output "inventory_ini" {
  value = module.ansible_inv.ini
}
output "inventory_yaml" {
  value = module.ansible_inv.yaml
}
output "inventory_json" {
  value = module.ansible_inv.json
}
output "inventory_files" {
  value = module.ansible_inv.inv_files
}
