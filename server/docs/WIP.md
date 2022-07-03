# Server Re-design Notes

At the moment, my server is really badly designed. I hacked everything together because I was figuring it out as I was building it. I knew nothing about countainers, networking, scripting etc. and I didn't document anything, so I don't know how any of it works now.

## Design

### Configuration

Ansible for the host machines, with Ansible Vault to encrypt and version control secrets.

Kubernetes manifest files for the Podman containers (_ref5_), and may be able to use the Renovate bot to keep packages up to date, as it can apparently detect new versions of container images from manifest files (_ref6_) (example: https://github.com/eifrach/ansible-role-assisted-installer-pod/).

### Operating System

Since there will be more than one machine in the 'cluster', I plan to use the following OSs:

- Home - OpenSUSE MicroOS
- VPS - Fedora Server

Both OSs support automatic updates; Fedora via DNF Automatic (_ref1_) and MicroOS via the default system behaviour (_ref2_). For the home server, OpenSUSE Tumbleweed (which MicroOS is based on) is incredibly stable (_ref3_) as the updates are automatically tested before being pushed out (_ref4_).

Other good things, mainly about MicroOS: the root file system is immutable; it's designed for container workloads and the automatic updates are atomic & transactional (will be automatically rolled back if something goes wrong).

Both operating systems will have access to new packages, unlike the Debian 10 installation that I have at the moment on my home server, which only has old versions of packages at the system-level.

Also, now that I am using Fedora on my laptop, I'm more comfortable with that family of Linux than I am with Debian so it makes sense to move the servers that way as well.

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

[Send notifications when SSH sessions starts and ends](https://old.reddit.com/r/selfhosted/comments/mihcl2/checklist_for_hardening_a_linux_vps/gt4vvev/). May be a bit spammy for commands that use SSH (e.g. `rsync`) but worth a try? Example [here](https://askubuntu.com/questions/179889/how-do-i-set-up-an-email-alert-when-a-ssh-login-is-successful).

### Proper Nextcloud Setup

My current setup is atrocious. Really slow and bloated.

According to [someone on Reddit](https://old.reddit.com/r/selfhosted/comments/mbc2uz/leaving_nextcloud_from_heaven_to_the_depths_of/gry2cpz/), you can massively improve the performance by actually setting things up properly (shocking, isn't it?). The other thing is that you should disable everything that you aren't using; in my case this would mean leaving only the 'Files' part of Nextcloud in place.

Some resources for Nextcloud container setup:

- https://github.com/DoTheEvo/selfhosted-apps-docker/tree/master/nextcloud
- https://github.com/kha7iq/selfhosted/blob/master/services/nextcloud.yml (just Nextcloud, no caching/db/etc...)

### Single Sign-On

Authelia, can function as an OpenID Connect provider (though this is still in Beta at the moment). Apparently (_ref8_) if you set up Nextcloud to use OIDC login with Authelia, it will work with the mobile app!

I'm already using Authelia with LDAP as a barrier in front of my apps, but I think with OIDC it will get even better.

I need to figure out how to better manage the LDAP users though. I'm not good at it.

### Dynamic DNS

Use a custom Python script to manage it.

### Uptime monitoring

Use something like [Healthchecks](https://healthchecks.io/) or [Uptime Kuma](https://uptime.kuma.pet/) to keep track of things.

Healthchecks uses a client-side ping, whereas I think Uptime Kuma uses a server side ping, so it depends which one suits my setup. Healthchecks is designed around recurring jobs, and can integrate with anything, so could be worth a try?

Uptime Kuma on the other hand seems easier to self-host. It can be loosely integrated with auth walls like Authelia (_ref9_) by disabling the Uptime Kuma auth and proxying through Authelia. If you do this, you should require login for the admin pages, but keep the public status page open.

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
