variable "formats" {
  type        = set(string)
  default     = []
  description = "The list of formats to output the Ansible inventory. Supported formats are: 'ini', 'yaml', and 'json'."

  validation {
    condition     = length(setunion(["ini", "yaml", "json"], var.formats)) <= 3
    error_message = "The supported formats are 'ini', 'yaml', and 'json'. An unsupported format was specified."
  }
}

variable "instances" {
  type = set(object({
    name = string
    ip   = string
  }))
  default     = []
  description = "The instances and their attributes to populate the Ansible inventory file."
}
