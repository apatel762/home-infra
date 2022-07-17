# Server Re-design Notes

At the moment, my server is really badly designed. I hacked everything together because I was figuring it out as I was building it. I knew nothing about countainers, networking, scripting etc. and I didn't document anything, so I don't know how any of it works now.

## Design

### Configuration

Ansible for the host machines, with Ansible Vault to encrypt and version control secrets.

Kubernetes manifest files for the Podman containers (_ref5_), and may be able to use the Renovate bot to keep packages up to date, as it can apparently detect new versions of container images from manifest files (_ref6_) (example: https://github.com/eifrach/ansible-role-assisted-installer-pod/).

Remote view of system with [Cockpit](https://cockpit-project.org/). Provides a web interface that can be used to manage the system. If you configure `journald` as a logging driver for all running containers, you can then view the container logs here, which is useful because you then don't need to SSH to the system directly. This web interface should, of course, be locked down and **NOT** accessible from the wider internet.

### Operating System

Since there will be more than one machine in the 'cluster', I plan to use the following OSs:

- Home - OpenSUSE MicroOS
- VPS - Fedora Server

Both OSs support automatic updates; Fedora via DNF Automatic (_ref1_) and MicroOS via the default system behaviour (_ref2_). For the home server, OpenSUSE Tumbleweed (which MicroOS is based on) is incredibly stable (_ref3_) as the updates are automatically tested before being pushed out (_ref4_).

Other good things, mainly about MicroOS: the root file system is immutable; it's designed for container workloads and the automatic updates are atomic & transactional (will be automatically rolled back if something goes wrong).

Both operating systems will have access to new packages, unlike the Debian 10 installation that I have at the moment on my home server, which only has old versions of packages at the system-level.

Also, now that I am using Fedora on my laptop, I'm more comfortable with that family of Linux than I am with Debian so it makes sense to move the servers that way as well.

### SELinux

**EDIT:** Have just discovered that OpenSUSE prefers AppArmor to SELinux, and though you can enable SELinux, they don't have any default policies (so you'd have to manage it entirely yourself). Could either use AppArmor or go for something like Fedora CoreOS instead.

SELinux must be enabled.

Thankfully, [MicroOS supports SELinux](https://en.opensuse.org/Portal:MicroOS/SELinux) **however** it is [not enabled out of the box](https://lists.opensuse.org/archives/list/selinux@lists.opensuse.org/thread/FVL5VUZDONYY7N3TXQVBUBQPRPZD3AGY/) due to some missing functionality in YaST.

You can still enable it manually:

```bash
transactional-update setup-selinux
```

and then check the status with the `sestatus` command. There are a couple of things that you need to be careful with when using SELinux on MicroOS.

1. You need to enable auto-relabelling of the file system (`touch /etc/selinux/.autorelabel`).
2. You need to mount container volumes with `:z` or `:Z` to integrate with SELinux.

Lowercase 'z' means that a shared label will be applied to the mount, so other containers can access it, whereas the uppercase 'Z' means that a private label will be applied and only that container may access the mount.

See also "[SELinux For Mere Mortals](https://www.youtube.com/watch?v=MxjenQ31b70)" (talk given by Thomas Cameron of Red Hat back in 2012)

### VPN

I want to rip out my dependency on Cloudflare. At the moment, I have moved the DNS records for my home server to Cloudflare so that I can take advantage of the Cloudflare proxy to hide my home IP address (and protect from various attacks).

I still want to hide my IP address from the global internet, but I don't want to proxy my traffic through Cloudflare. The most popular way of achieving this is to set up a VPS in a public cloud and use that as a dumb router for traffic.

- ["Why use a VPS?"](https://old.reddit.com/r/selfhosted/comments/i6jo44/why_use_a_vps/g0w9bjl/), _([Archived](https://web.archive.org/web/20220703093236/https://old.reddit.com/r/selfhosted/comments/i6jo44/why_use_a_vps/g0w9bjl/))_
- ["Depending on your paranoid level, you may prefer a TCP proxy, instead of a HTTP(S) proxy installed on the DigitalOcean droplet [...]"](https://old.reddit.com/r/selfhosted/comments/ndugg5/reverse_proxy_noob_wanting_to_learn/gycvkc5/)
- [WireGuard HAProxy Gateway](https://theorangeone.net/posts/wireguard-haproxy-gateway/)

The plan would be to use HAProxy to establish a TCP proxy connection between the VPS and my home server (the VPS would act as a dumb router for outside traffic).

Mildly related, you can easily manage a Wireguard mesh network using Ansible by generating the config automatically using Jinja templates and pushing it out to the nodes (which is usually quite difficult if you were to do it manually). You can also push out `/etc/hosts` changes to every node so that they can all talk to each other using the same name.

### Notifications

Email; Fastmail via Postfix (_ref7_). Add custom domain to Fastmail so that sending and receiving is OK and doesn't appear to come from my personal address (even though it technically is?).

[Send notifications when SSH sessions starts and ends](https://old.reddit.com/r/selfhosted/comments/mihcl2/checklist_for_hardening_a_linux_vps/gt4vvev/). May be a bit spammy for commands that use SSH (e.g. `rsync`) but worth a try? Example [here](https://askubuntu.com/questions/179889/how-do-i-set-up-an-email-alert-when-a-ssh-login-is-successful) and another example (using Telegram instead of email) [here](https://blog.tommyku.com/blog/send-telegram-notification-on-ssh-login/).

### Proper Nextcloud Setup

My current setup is atrocious. Really slow and bloated.

According to [someone on Reddit](https://old.reddit.com/r/selfhosted/comments/mbc2uz/leaving_nextcloud_from_heaven_to_the_depths_of/gry2cpz/), you can massively improve the performance by actually setting things up properly (shocking, isn't it?). The other thing is that you should disable everything that you aren't using; in my case this would mean leaving only the 'Files' part of Nextcloud in place.

Some resources for Nextcloud container setup:

- https://github.com/DoTheEvo/selfhosted-apps-docker/tree/master/nextcloud
- https://github.com/kha7iq/selfhosted/blob/master/services/nextcloud.yml (just Nextcloud, no caching/db/etc...)

### Single Sign-On

Authelia, can function as an OpenID Connect provider (though this is still in Beta at the moment). Apparently (_ref8_) if you set up Nextcloud to use OIDC login with Authelia, it will work with the mobile app!

I'm already using Authelia with LDAP as a barrier in front of my apps, but I think with OIDC it will get even better.

I need to figure out how to better manage the LDAP users though. I'm not good at it. Found [this comment](https://news.ycombinator.com/item?id=32056659) on Hacker News saying:

> It's trivial to reload openldap data from ldif, so you can already manage LDAP via Ansible easily enough

...in response to somebody else saying that you should try a different user directory service to make it easy to manage. I didn't know about LDIF before, but perhaps I could use that to manage users. On top of that, Ansible has some pre-built roles that you can use to manage LDAP - [community.general.ldap_entry](https://docs.ansible.com/ansible/latest/collections/community/general/ldap_entry_module.html).

See also [Use LDIF files to make changes on an OpenLDAP system](https://www.digitalocean.com/community/tutorials/how-to-use-ldif-files-to-make-changes-to-an-openldap-system)

### Dynamic DNS

Use a custom Python script to manage it.

### Uptime monitoring

Use something like [Healthchecks](https://healthchecks.io/) or [Uptime Kuma](https://uptime.kuma.pet/) (preferred) to keep track of things.

Uptime Kuma supports monitoring in both directions. Kuma can ping servers and perform checks by itself, but it also supports client-side health checks via push-based monitoring (see https://github.com/louislam/uptime-kuma/ issue 279).

Also, of the two monitoring systems, Uptime Kuma seems easier to self-host. It can also be loosely integrated with auth walls like Authelia (_ref9_) by disabling the built-in Uptime Kuma authentication and proxying through Authelia. If you do this, you should require Authelia login for the admin pages, but allow users to bypass Authelia for the public status page.

Not sure how Authelia will work though, if Uptime Kuma is hosted on a VPS? Something to think about.

### Miscellaneous

Use different users to deploy each set of services. Have a separate user only to be used for administrator actions; this user will be part of the `sudoers` list but will not be used to run any services.

The `root` user on all systems will be disabled and access to `root`-level operations will be managed entirely through using `sudo`.

Potentially could use [GeoIP blocks](https://www.ipdeny.com/ipblocks/) to restrict traffic to certain countries only? Not sure how that would work when I am travelling though. It also wouldn't work on my phone as I am using iCloud Private Relay.

## References

1. https://dnf.readthedocs.io/en/latest/automatic.html
2. en.opensuse.org. ["Always up-to-date: Updates are automatically applied without impacting the running system"](https://en.opensuse.org/Portal:MicroOS)
3. old.reddit.com, 2021. ["The resilience of Tumbleweed (or why you can trust it as much as Leap/Debian) -- 227 days between updates"](https://old.reddit.com/r/openSUSE/comments/ok59wy/the_resilience_of_tumbleweed_or_why_you_can_trust/)
4. https://openqa.opensuse.org/
5. docs.ansible.com. ["Play kubernetes YAML file using podman"](https://docs.ansible.com/ansible/latest/collections/containers/podman/podman_play_module.html)
6. docs.renovatebot.com. ["Renovate supports upgrading dependencies in various types of Docker definition files [...] Kubernetes manifest files"](https://docs.renovatebot.com/docker/)
7. https://www.brull.me/postfix/debian/fastmail/2016/08/16/fastmail-smtp.html
8. old.reddit.com, 2021. ["Authelia OpenID with NextCloud"](https://old.reddit.com/r/selfhosted/comments/r4zk43/authelia_openid_with_nextcloud/)
9. github.com, 2021. https://github.com/louislam/uptime-kuma/ issue 553
