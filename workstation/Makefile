all:
	@echo "no-op. Please use a specific make target."

install:
	@./install.sh

apply:
	venv/bin/ansible-playbook playbook.yml --inventory hosts.ini --ask-become-pass