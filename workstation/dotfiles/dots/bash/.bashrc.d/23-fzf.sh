# This snippet will install fzf if it's not already installed.
# The installation will happen by cloning the git repo.
if ! command -v fzf &>/dev/null; then
	echo "Installing fzf..."
	if command -v ghq &>/dev/null; then
		ghq get https://github.com/junegunn/fzf.git \
			&& "$(ghq list -p | grep "github.com/junegunn/fzf")"/install \
				--xdg \
				--all \
				--no-update-rc
		# using --no-update-rc above because we've already got the relevant
		# snippet for sourcing the autocompletions below (so we don't want
		# the installer to be 'helpful' and add it for us)
	else
		echo "Cannot install fzf without ghq... Run the configuration playbook and try again."
	fi
fi

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] \
    && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

