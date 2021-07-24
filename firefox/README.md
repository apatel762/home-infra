# Firefox

I use some customisations for Firefox that can't easily be worked into the Ansible config, so I will document them here.

## Dependencies

Wehner, Joshua (February 1, 2016). "[Working with submodules](https://github.blog/2016-02-01-working-with-submodules/)". *[Archived](https://web.archive.org/web/20210724123412/https://github.blog/2016-02-01-working-with-submodules/)*. Retrieved July 24, 2021.

The submodules were added using the following commands:

```bash
git submodule add https://github.com/vinceliuice/WhiteSur-gtk-theme whitesur
git submodule add https://github.com/arkenfox/user.js userjs
```

We depend on these repos for custom Firefox theming and configuration/hardening.