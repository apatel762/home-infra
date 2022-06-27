all:
	@echo "no-op. Please use a specific make target."

clean:
	@rm -rf ./venv
	@rm -rf $(HOME)/.ansible

install:
	@./scripts/install.sh

apply:
	@ssh ::1 bash < ./scripts/await-ostree-idle.sh
	source venv/bin/activate && ansible-playbook playbook.yml --inventory hosts.ini --ask-become-pass --ask-pass
