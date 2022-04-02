# Step 3: Setup local Python install

Links:

- [Previous](./02-AcquireRepo.md)
- [Next](./04-AnsiblePlaybook.md)

---

Don't want to use the global installation of Python for anything. This is to ensure that we don't accidentally cause something to break in our global/system installation of Python years down the line. Everything should be isolated and installed at the user-level.

## `pyenv` 

Get the `pyenv` repo and install it to your local software folder:

```bash
git clone https://github.com/pyenv/pyenv.git ~/.local/share/.pyenv
```

**At this point, you will want to set up the dotfiles**; follow the instructions [here](../dotfiles/README.md) and open a new terminal window (to pick up the changes) before continuing.

### No more system Python!

Now that `pyenv` is installed, we can begin running some commands that will ensure that we never use the system installation of Python. First, install the build environment dependencies into a toolbox container:

```bash
# create fresh toolbox for installing build deps
toolbox create pyenv-stuff
toolbox enter pyenv-stuff

sudo dnf update vte-profile  # https://github.com/containers/toolbox/issues/390
sudo dnf install "@Development Tools" zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils
```

Then, while we are still in the toolbox, run these commands to find and install the latest version of Python. I'm using 3.10.4 as an example but the latest stable version may be different later on!

```bash
# find the latest stable version of Python
pyenv install --list | less

# install that version of Python
pyenv install 3.10.4
pyenv global 3.10.4
```

The `pyenv global` command will tell the `pyenv` shim to always default to the selected local `pyenv` installation of Python, unless it's overridden somewhere else (e.g. with a `.python-version` file).

## `pipx`

We're going to install `pipx` via a virtual environment, following the theme of '*I dont want to touch the system Python dependencies with a 10-foot pole*'.

The only system packages that we are going to install are `setuptools` and `wheel`. I think this is fine compared to installing everything that `pipx` depends on *and* those two packages.

Run the below commands inside of the toolbox that you created earlier (to ensure that you still have access to all of those dependencies that you installed into the toolbox earlier):

```bash
mkdir -p /tmp/pipx-in-pipx
cd /tmp/pipx-in-pipx
python -m pip install --upgrade pip setuptools wheel
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install --upgrade pipx
pipx install pipx --force
pipx ensurepath
deactivate
rm -rf .venv
rm ~/.local/pipx/venvs/pipx/bin/python
ln -s "$(pyenv prefix)/bin/python" ~/.local/pipx/venvs/pipx/bin/python
```

...and if it's all worked, `pipx` should still be available:

```bash
pipx --version
```

Also, it should be managing itself (`ls -al ~/.local/pipx/venvs` will contain `pipx`) which will make it easier to uninstall it later on if we want to re-install it with a newer version of Python (see Cleanup section below).

## Cleanup

You can destroy the toolbox that you created as we no longer need it.

```bash
toolbox rm --force pyenv-stuff
```

...and if you don't want to use `pipx` any more (or you want to re-install it using a newer version of Python), run these commands to remove the current installation (**this will remove all installed apps**):

```bash
pipx uninstall-all
rm -f ~/.local/bin/pipx
rm -rf ~/.local/pipx
```

## References

1. [Suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) for pyenv.
