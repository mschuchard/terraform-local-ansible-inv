# vars for dynamic variation of parameters
variable "formats" { type = set(any) }

variable "instances_var" {}

# mock platform instances
variable "instances_aws" {}
variable "instances_gcp" {}
variable "instances_azr" {}
variable "instances_vsp" {}

# mock group vars
variable "group_vars" {}

# mock extra provider instance hostvars
variable "extra_hostvars" {}
