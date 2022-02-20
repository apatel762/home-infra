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

TODO: Write an install.sh script. The script should:

- Create a python venv
- Install ansible (& any other important stuff) via `requirements.txt`
- Install the ansible-galaxy collections in `requirements.yaml`

TODO: create a `Makefile` with targets that will help you:

- Run the above install.sh script
- Apply the playbook

Check the variables in `group_vars/all` and make sure you're happy with everything that is about to be installed onto the machine.
