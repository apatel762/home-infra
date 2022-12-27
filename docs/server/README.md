# Server

The configuration for my home server & related infrastructure. The rough design for the new server architecture is [here](./00-BroadwaterV2.md). The rest of the documentation is ongoing.

## Pre-bootstrap

Provision the various servers (physical hardware) and install the operating systems.

For all servers, add entries to `/etc/hosts` on the machine that you are deploying from, such that the Ansible inventory makes sense. This will involve finding the IP addresses of the machines and manually updating the `/etc/hosts` file using `sudoedit`.

Test Ansible connection using an ad-hoc ping command, like below:

```bash
ansible --inventory hosts.ini vps -m ping -u root
```

Don't forget to enter the Python virtual environment, you may need to run `make install` first.
