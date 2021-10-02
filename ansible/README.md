# Ansible

Some things to note about the Ansible setup.

To make it so that you don't have to memorise the really long command that you need to run each time you want to run the playbook, I've created a wrapper script called `run.sh`.

Look in there to see how Ansible is being used.

## Ansible Vault

Some notes about how I've used Ansible Vault to encrypt things.

Encrypt and play with the file as normal

```bash
ansible-vault encrypt foo.yml
ansible-vault view foo.yml
ansible-vault edit foo.yml
```

Change password used to encrypt

```
ansible-vault rekey foo.yml
```

Remove all encryption

```
ansible-vault decrypt foo.yml
```

Run playbook that contains encrypted stuff

```
ansible-playbook --ask-vault-pass playbook.yml
ansible-playbook --vault-password-file /path/to/vault-password-file playbook.yml
```

And with multiple vaults

```
ansible-playbook --vault-id dev@dev-password --vault-id prod@prompt playbook.yml
```

where:

- 1st vault = `dev`, `dev-password` is the path to the file with the vault password
- 2nd vault = `prod`, `prompt` means Ansible will prompt you for the password
