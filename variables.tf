# inventory formatting
variable "formats" {
  type        = set(string)
  default     = []
  description = "The set of formats in which to output the Ansible inventory. Supported formats are: 'ini', 'yaml', and 'json'."

  validation {
    condition     = length(setunion(["ini", "yaml", "json"], var.formats)) <= 3
    error_message = "The supported formats are 'ini', 'yaml', and 'json'. An unsupported format was specified."
  }
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix to prepend to the name of the output inventory files. For example: the INI inventory will be named 'PREFIXinventory.ini'. This is primarily useful for unique naming schemes between module declarations."
}

variable "inv_file_perms" {
  type        = string
  default     = "0644"
  description = "The file permissions octal mode for the output Ansible inventory file(s)."

  validation {
    condition     = can(regex("^\\d{4}$", var.inv_file_perms))
    error_message = "The permissions mode must be in four digit octal notation."
  }
}

variable "manage_file" {
  type        = bool
  default     = true
  description = "Whether or not to manage a local file per inventory format with the content of each inventory. If this is set to false, then the inventory content will only be available from the Terraform outputs."
}

# hosts and host vars
variable "instances" {
  type = map(object({
    children = set(string)
    hosts = set(
      object({
        name = string
        ip   = string
        vars = map(string)
      })
    )
  }))
  default     = {}
  description = "The instances and their attributes used to populate the Ansible inventory file. The map keys will be used to construct Ansible inventory groups with the paired 'hosts' object values as the group host members."
}

variable "instances_aws" {
  type        = any
  default     = {}
  description = "The 'aws_instance.this' map of objects comprising multiple instances to populate the Ansible inventory file."
}

variable "instances_gcp" {
  type        = any
  default     = {}
  description = "The 'google_compute_instance.this' map of objects comprising multiple instances to populate the Ansible inventory file."
}

variable "instances_azr" {
  type        = any
  default     = {}
  description = "The 'azurerm_linux|windows_virtual_machine.this' map of objects comprising multiple instances to populate the Ansible inventory file."
}

variable "instances_vsp" {
  type        = any
  default     = {}
  description = "The 'vsphere_virtual_machine.this' map of objects comprising multiple instances to populate the Ansible inventory file."
}

# groups
variable "group_vars" {
  type        = map(any)
  default     = {}
  description = "The map of Ansible group variables. Each key in the map is the name of a group (this includes support for the 'all' group), and each value is the object representing the pairs of group variable names and values."
}

# update attributes of provider instances
variable "extra_hostvars" {
  type = object({
    aws = map(map(string))
    gcp = map(map(string))
    azr = map(map(string))
    vsp = map(map(string))
  })
  default = {
    aws = {}
    gcp = {}
    azr = {}
    vsp = {}
  }
  description = "An object comprising additional host variables to append to the variables automatically derived from the directly mapped provider instances' attributes. The format of the maps for each provider platform key should be key=HOST value={VARNAME = VARVALUE}."
}
