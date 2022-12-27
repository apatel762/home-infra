# OSTree Update Policy

A role for managing the `rpm-ostreed.conf` settings. The only interesting thing that we're doing here is configuring the automatic staging of updates. This will mean that, after running this Ansible role, affected systems will automatically check for updates **and** stage them, in the background. The changes will then be picked up the next time the machines are restarted.

After running this role, you can use the below command to see all changes to `/etc` from the base OS image.

```bash
sudo ostree admin config-diff
```

## References

1. `man rpm-ostreed.conf`
2. [j1mc/ansible-silverblue](https://github.com/j1mc/ansible-silverblue)
