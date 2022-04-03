
all:
	@echo "no-op. Please use a specific make target."

install:
	@./scripts/install.sh

apply:
	@./scripts/await-ostree-idle.sh
	source venv/bin/activate && ansible-playbook playbook.yml --inventory hosts.ini --ask-become-pass
