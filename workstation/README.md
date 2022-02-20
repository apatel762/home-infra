# Workstation

Running Fedora Silverblue.

Currently just using a VM, but eventually, will migrate my main workstation to use this.

## Preparation

Since you can't install things on Silverblue as you would normally (`rpm-ostree` is only recommended for stuff that you *really* need system-wide and can't use in *just* toolbox containers), I'm going to write down the manual steps here.

Clone this repo to the machine:

```bash
ANSIBLE_PLAYBOOK_FOLDER="$HOME/Projects/github.com/apatel762"

mkdir -p "$ANSIBLE_PLAYBOOK_FOLDER"
cd "$ANSIBLE_PLAYBOOK_FOLDER"

git clone https://github.com/apatel762/home-infra.git
cd "home-infra/workstation"
```

## Usage

Use:

```bash
make install
```

to set up any required software. Everything will be installed into a Python virtual environment, so it will all live inside of this folder and you won't have to worry about it polluting your system.

You will need to have at least Python 3.8 for the installation to succeed. If `python` doesn't point to a recent enough version of Python, then you might want to use something like `pyenv` to change the active version of Python for this repo (just so that you can create the virtual environment, after that it doesn't matter).

Once the installation is done, check the variables in the `group_vars/all` file and make sure you're happy with everything that is about to be installed onto (or removed from) the machine.

When you're happy with the group vars, use:

```
make apply
```

to run the playbook. It will prompt you for your `sudo` password - this is needed to change any of package overlays and remove any system flatpaks.
