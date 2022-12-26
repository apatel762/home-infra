# Broadwater V2

At the moment, my server is really badly designed.

I hacked everything together because I was figuring things out as I was going along. I knew nothing about countainers, networking, scripting, and general server administration. I also didn't document anything, so I don't know how any of it works now.

My plan is to re-install the operating system and do things properly.

My server is called 'Broadwater', so this design is going over what I'm going to call: 'Broadwater V2'.

## Design

### Configuration

**Ansible** for the host machines, with **Ansible Vault** to encrypt and version control secrets.

**Kubernetes manifest files for the Podman containers**. May also be able to use the Renovate bot to keep packages up to date, as it can apparently detect new versions of container images from manifest files (example: https://github.com/eifrach/ansible-role-assisted-installer-pod/).

```yaml
- name: Ensure that Kubernetes YAML file for pod is present on server
  template:
    src: "pod.j2"
    dest: "/somewhere/on/my/server/pod.yaml"

- name: Ensure that the config mapping file is present on the server
  template:
    src: "configmap.j2"
    dest: "/somewhere/on/my/server/configmap.yaml"

- name: Ensure that the pod is running using the provided manifest and configuration
  containers.podman.podman_play:
    kube_file: "/somewhere/on/my/server/pod.yaml"
    configmap: 
      - "/somewhere/on/my/server/configmap.yaml"
    state: started
```

Refs.:

- [pod.j2](https://github.com/eifrach/ansible-role-assisted-installer-pod/blob/ac0cca8ce1ecc7b2d433b20f3a22d980dbe63d25/templates/pod.j2)
- [configmap.j2](https://github.com/eifrach/ansible-role-assisted-installer-pod/blob/ac0cca8ce1ecc7b2d433b20f3a22d980dbe63d25/templates/configmap.j2)

### Operating System

Since there will be more than one machine in the 'cluster', I plan to use the following OSs:

- Home - Fedora IoT
- VPS - Fedora Server

Both OSs support automatic updates: Fedora Server via DNF Automatic and IoT via `rpm-ostreed-automatic.service`. Fedora IoT has an immutable root filesystem, and is managed similar to Fedora Silverblue (which I am using on my laptop...) so I think it's a no-brainer here.

### SELinux

SELinux must be enabled. Fedora IoT has it enabled by default, so we should be OK here.

**There are a couple of things that you need to be careful with when using SELinux with containers**.

1. You need to enable auto-relabelling of the file system (`touch /etc/selinux/.autorelabel`).
2. You need to mount container volumes with `:z` or `:Z` to integrate with SELinux.

Lowercase 'z' means that a shared label will be applied to the mount, so other containers can access it, whereas the uppercase 'Z' means that a private label will be applied and only that container may access the mount.

See also "[SELinux For Mere Mortals](https://www.youtube.com/watch?v=MxjenQ31b70)" (talk given by Thomas Cameron of Red Hat back in 2012)

### VPN

**A VPN should connect the home server to a remote VPS**. Traffic will be sent to the home server from outside the home network via a TCP proxy, managed by a load balancer on the VPS.

This eliminates the need to use Cloudflare for hiding my home IP, and it also eliminates the need for hacky dynamic DNS scripts, because a VPS either has a static hostname or a static IP.

- ["Why use a VPS?"](https://old.reddit.com/r/selfhosted/comments/i6jo44/why_use_a_vps/g0w9bjl/), _([Archived](https://web.archive.org/web/20220703093236/https://old.reddit.com/r/selfhosted/comments/i6jo44/why_use_a_vps/g0w9bjl/))_
- ["Depending on your paranoid level, you may prefer a TCP proxy, instead of a HTTP(S) proxy installed on the DigitalOcean droplet [...]"](https://old.reddit.com/r/selfhosted/comments/ndugg5/reverse_proxy_noob_wanting_to_learn/gycvkc5/)
- [WireGuard HAProxy Gateway](https://theorangeone.net/posts/wireguard-haproxy-gateway/)

### Notifications

Email; **Fastmail via Postfix**. Add custom domain to Fastmail so that sending and receiving is OK and doesn't appear to come from my personal address (even though it technically is?).

[Send notifications when SSH sessions starts and ends](https://old.reddit.com/r/selfhosted/comments/mihcl2/checklist_for_hardening_a_linux_vps/gt4vvev/). May be a bit spammy for commands that use SSH (e.g. `rsync`) but worth a try? Example [here](https://askubuntu.com/questions/179889/how-do-i-set-up-an-email-alert-when-a-ssh-login-is-successful) and another example (using Telegram instead of email) [here](https://blog.tommyku.com/blog/send-telegram-notification-on-ssh-login/).

### Proper Nextcloud Setup

My current setup is atrocious. Really slow and bloated.

According to [someone on Reddit](https://old.reddit.com/r/selfhosted/comments/mbc2uz/leaving_nextcloud_from_heaven_to_the_depths_of/gry2cpz/), you can massively improve the performance by actually setting things up properly (shocking, isn't it?). The other thing is that you should disable everything that you aren't using; in my case this would mean leaving only the 'Files' part of Nextcloud in place.

Some resources for Nextcloud container setup:

- https://github.com/DoTheEvo/selfhosted-apps-docker/tree/master/nextcloud
- https://github.com/kha7iq/selfhosted/blob/master/services/nextcloud.yml (just Nextcloud, no caching/db/etc...)

### Single Sign-On

Authelia, can function as an OpenID Connect provider (though this is still in Beta at the moment). Apparently if you set up Nextcloud to use OIDC login with Authelia, it will work with the mobile app!

With Broadwater V2, the plan is to use **Authelia (for auth management) with LDAP (for user management)**.

I'm already using Authelia with LDAP as a barrier in front of my apps, but I think with OIDC it will get even better.

I need to figure out how to better manage the LDAP users though. I'm not good at it. Found [this comment](https://news.ycombinator.com/item?id=32056659) on Hacker News saying:

> It's trivial to reload openldap data from ldif, so you can already manage LDAP via Ansible easily enough

...in response to somebody else saying that you should try a different user directory service to make it easy to manage. I didn't know about LDIF before, but perhaps I could use that to manage users. See also "[Use LDIF files to make changes on an OpenLDAP system](https://www.digitalocean.com/community/tutorials/how-to-use-ldif-files-to-make-changes-to-an-openldap-system)".

Alternatively, Ansible has some pre-built roles that you can use to manage LDAP - [community.general.ldap_entry](https://docs.ansible.com/ansible/latest/collections/community/general/ldap_entry_module.html).

### Dynamic DNS

Not sure if this is needed, but if it is:

Use a custom Python script to manage it. The script should only use the standard Python library so that there are no dependencies on 3rd party libs that we need to install when we configure the server.

We can manage the running of the script using a `systemd` timer.

### Uptime monitoring

Use [Uptime Kuma](https://uptime.kuma.pet/) to keep track of things.

Uptime Kuma supports monitoring in both directions. Kuma can ping servers and perform checks by itself, but it also supports client-side health checks via push-based monitoring (see https://github.com/louislam/uptime-kuma/ issue 279).

### Miscellaneous

Use different users to deploy each set of services. Have a separate user only to be used for administrator actions; this user will be part of the `sudoers` list but will not be used to run any services.

The `root` user on all systems will be disabled and access to `root`-level operations will be managed entirely through using `sudo`.

Potentially could use [GeoIP blocks](https://www.ipdeny.com/ipblocks/) to restrict traffic to certain countries only? Not sure how that would work when I am travelling though. It also wouldn't work on my phone as I am using iCloud Private Relay.

## References

1. https://dnf.readthedocs.io/en/latest/automatic.html
2. docs.ansible.com. ["Play kubernetes YAML file using podman"](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_play_module.html)
3. docs.renovatebot.com. ["Renovate supports upgrading dependencies in various types of Docker definition files [...] Kubernetes manifest files"](https://docs.renovatebot.com/docker/)
4. https://www.brull.me/postfix/debian/fastmail/2016/08/16/fastmail-smtp.html
5. old.reddit.com, 2021. ["Authelia OpenID with NextCloud"](https://old.reddit.com/r/selfhosted/comments/r4zk43/authelia_openid_with_nextcloud/)
6. github.com, 2021. https://github.com/louislam/uptime-kuma/ issue 553
