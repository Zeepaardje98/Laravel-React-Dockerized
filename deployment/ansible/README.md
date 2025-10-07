# Ansible for HashiCorp Vault

This automation installs and configures Vault on the droplet created by the 02-digitalocean-vault Terraform stack.

Prerequisites
- Python and Ansible installed on your control machine (or run from CI)
- SSH access to the Vault droplet (SSH key already provisioned by Terraform)
- Terraform output vault_droplet_ip

Quick start
1) Export the droplet IP into inventory:
   - Option A (static): edit inventory/hosts.ini and set the host.
   - Option B (ad-hoc): pass -i <vault_ip>, to Ansible.
2) Run the playbook:
```
ansible-playbook -i inventory/hosts.ini site.yml
```
   Or ad-hoc inventory:
```
ansible-playbook -i "${VAULT_IP}," -e ansible_user=root site.yml
```

Notes
- The default config runs Vault without TLS for bootstrap. Add TLS cert/key paths in group_vars/vault.yml to enable TLS and restart.
- Do NOT place unseal keys or root tokens in Ansible; handle initialization/unseal separately.

## Playbooks

- playbooks/vault.yml: installs and configures Vault on hosts in the `vault` group.
  - Example: `ansible-playbook -i "${VAULT_IP}," -e ansible_user=root playbooks/vault.yml`
- playbooks/user.yml: creates a Linux user with SSH access on target hosts.
  - Example: `ansible-playbook -i "${HOST}," -e ansible_user=root -e user_name=deploy -e user_authorized_keys="['ssh-ed25519 AAA...']" playbooks/user.yml`

