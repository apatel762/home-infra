# Firefox

I use some customisations for Firefox that can't easily be worked into the Ansible config, so I will document them here.

## Dependencies

### Adding submodules

Wehner, Joshua (February 1, 2016). "[Working with submodules](https://github.blog/2016-02-01-working-with-submodules/)". *[Archived](https://web.archive.org/web/20210724123412/https://github.blog/2016-02-01-working-with-submodules/)*. Retrieved July 24, 2021.

The submodules were added using the following commands:

```bash
git submodule add https://github.com/vinceliuice/WhiteSur-gtk-theme whitesur
git submodule add https://github.com/arkenfox/user.js userjs
```

We depend on these repos for custom Firefox theming and configuration/hardening.

### Removing submodules

VonC (April 23, 2013). "[How do I remove a submodule?](https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule/16162000#16162000)". *[Archived](https://web.archive.org/web/20210811213825/https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule/16162000)*. Retrieved August 11, 2021.

You can remove a submodule using these commands (all of the commands were run from this folder):

```bash
# (optional?) rename the submodule folder
# mv whitesur/ whitesur_tmp

# de-register the submodule
git submodule deinit -f -- whitesur

rm -r ../.git/modules/firefox/whitesur/
git rm -f whitesur/

# and then commit the changes
```
