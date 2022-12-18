all:
	@echo "no-op. Please use a specific make target."

clean:
	@rm -rf ./venv
	#@rm -rf $(HOME)/.ansible

install:
	@./ansible/scripts/install.sh

workstation:
	./ansible/scripts/ws_dconf_settings.sh
	./ansible/scripts/ws_install_flatpaks.sh  # includes brave browser conf role
	./ansible/scripts/ws_os_updates.sh
	./ansible/scripts/ws_package_layering.sh
	./ansible/scripts/ws_standalone_apps.sh
