# inventory formatting vars
variable "formats" {
  type        = set(string)
  default     = []
  description = "The set of formats to output the Ansible inventory. Supported formats are: 'ini', 'yaml', and 'json'."

  validation {
    condition     = length(setunion(["ini", "yaml", "json"], var.formats)) <= 3
    error_message = "The supported formats are 'ini', 'yaml', and 'json'. An unsupported format was specified."
  }
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix to prepend to the name of the output inventory files. For example: the INI inventory will be named '<prefix>inventory.ini'."
}

# instance vars
variable "instances" {
  type = map(
    set(
      object({
        name = string
        ip   = string
        vars = map(string)
      })
    )
  )
  default     = {}
  description = "The instances and their attributes to populate the Ansible inventory file. The map keys will be used to construct Ansible inventory groups with the paired object values as the group host members."
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

# group vars
variable "group_vars" {
  type        = map(any)
  default     = {}
  description = "The map of Ansible group variables. Each key in the map is the name of a group, and each value is the object representing the pairs of group variable names and values."
}
