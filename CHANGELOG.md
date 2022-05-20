### 1.1.0 (Next)
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
