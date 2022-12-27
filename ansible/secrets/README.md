# Secrets

A folder to store secrets that will be used while we use the configuration playbook.

As an example, if you create a file called `vault_password` and put it in this folder, the scripts which run the Ansible playbooks will pass that file to Ansible and tell it to get the Vault password from there. This saves you from having to type it out every time you want to decrypt secrets.
