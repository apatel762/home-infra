
all:
	@echo "no-op. Please use a specific make target."

install:
	@./scripts/install.sh

apply:
	@./scripts/await-ostree-idle.sh
	venv/bin/ansible-playbook playbook-base.yml --inventory hosts.ini --ask-become-pass
