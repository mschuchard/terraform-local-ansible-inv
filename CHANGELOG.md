### 1.3.2 (Next)
- Reduce permissiveness of platform instance variables.

### 1.3.1
- Do not add empty platform groups to the inventory.
- Omit output for omitted formats instead of empty string value.

### 1.3.0
- Increaase minimum TF version from 0.13 to 1.0.
- Add `manage_file` variable.

### 1.2.1
- Add new variable for and support appending to host variables for provider instances.
- Improve assurance of output blocks' accuracy.
- Ignore redundant `Name` host variable for AWS instances.

### 1.2.0
- Update `instances` var to new type structure to support Ansible group children specification.
- Support Ansible inventory group children for `instances` variable.
- Remove empty section rendering in INI format Ansible inventory.

### 1.1.2
- Update ini inventory template for recent group changes.
- Safer handling of empty tag attributes in provider resources.
- Add `labels` and `metadata` attributes to host vars for GCP.

### 1.1.1
- Add `inv_files` output.
- Add `inv_file_perms` variable.
- Attempt to detect if Windows instance, and set transport to `winrm` if true.
- Fix inventory `all` group `hosts` entry type.

### 1.1.0
- Update `instances` var to `map(set(object))` to support Ansible group specification.
- Support Ansible inventory groups for `instances` variable.
- Add functionality for Ansible group variable dynamic population.

### 1.0.2
- Update Azure instances to use `name` argument from resource.
- Fix types for direct instance resource population.
- Add `ansible_become_user` auto-populate for Azure.
- Add `ansible_become_user` auto-populate for VSphere.
- Auto-populate groups for each input platform.

### 1.0.1
- Support direct input of AWS instance resource objects.
- Support direct input of GCP instance resource objects.
- Support direct input of Azure instance resource objects.
- Support direct input of VSphere instance resource objects.

### 1.0.0
- Initial Release
