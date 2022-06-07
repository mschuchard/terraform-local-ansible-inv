### 1.1.2 (Next)
- Update ini inventory template for recent group changes.
- Safer handling of empty tag attributes in provider resources.

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
