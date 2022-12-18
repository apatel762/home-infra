# Step 3: Configure machine with Ansible

Links:

- [Previous](./02-AcquireRepo.md)
- [Next](./04-ManualSetup.md)

**You should be in a toolbox container now**. Enter the folder with the Ansible playbook and use the Makefile to install dependencies.

```bash
make install
```

Before you run the playbook, check the settings in the `group_vars/local.yml` file. Your workstation will be configured using those settings. When you are happy, run the playbook.

```bash
make apply
```

If the playbook completes with no errors, your workstation has been configured. You may need to reboot to finalise some changes, keep an eye on the logs.
