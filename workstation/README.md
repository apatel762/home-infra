# Workstation

Running Fedora Silverblue.

Currently just using a VM, but eventually, will migrate my main workstation to use this.

## Usage

Since you can't install things on Silverblue as you would normally (`rpm-ostree` is only recommended for stuff that you *really* need system-wide and can't use in *just* toolbox containers), I'm going to write down the manual steps here.

Clone this repo to the machine:

```bash
CONFIG_FOLDER="$HOME/Projects/github.com/apatel762"

mkdir -p "$CONFIG_FOLDER"
cd "$CONFIG_FOLDER"

git clone https://github.com/apatel762/home-infra.git
```
