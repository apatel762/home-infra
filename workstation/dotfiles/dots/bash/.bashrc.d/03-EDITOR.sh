function _ensure_neovim_appimage_extracted() {
	local LOCAL_BIN
	LOCAL_BIN="$HOME/.local/bin"

	local EXPECTED_NEOVIM_BINARY
	EXPECTED_NEOVIM_BINARY="$LOCAL_BIN/nvim" 

	# if the symlink is broken, ensure that the target is removed
	# ...and remove the squashfs root while we're at it (if it's there)
	if [ ! -e "$EXPECTED_NEOVIM_BINARY" ] ; then
		rm -f "$EXPECTED_NEOVIM_BINARY" 
		rm -rf "$LOCAL_BIN/nvim-root"
	fi 

	if ! command -v nvim &>/dev/null \
		&& [ -f "$HOME/.local/bin/nvim.AppImage" ]; then
		# if we are in here, we have the AppImage in the local bin and we
		# DON'T have the plain Neovim binary, so here, we need to extract
		# it from the AppImage and create a symlink
		(
			echo "Creating physical nvim.AppImage alias"
			cd "$HOME/.local/bin/" 
			./nvim.AppImage --appimage-extract &>/dev/null

			# rename the fs root folder
			mv squashfs-root nvim-root

			# create symlink
			ln -s nvim-root/usr/bin/nvim nvim
		)
	fi
}

# if we've got 'nvim' then prioritise that over the other stuff
if command -v nvim &>/dev/null; then
	export VISUAL=nvim
	export EDITOR=nvim
	alias vi='vim'
	alias vim='nvim'
	[[ $(type -t nvim) == "alias" ]] && unalias nvim

	# using the Neovim AppImage on my workstation, so if it's present, this
	# init script will extract the AppImage and create the relevant
	# symlinks to make it all work (even when inside of a toolbox, where
	# you can't use FUSE mounts).
	_ensure_neovim_appimage_extracted


# if we've got 'vim', then use that over 'vi' to make things a little
# bit easier to use
elif command -v vim &>/dev/null; then
	export VISUAL=vim
	export EDITOR=vim
	alias vi='vim'
	[[ $(type -t vim) == "alias" ]] && unalias vim
	alias nvim='vim'

# we definitely should have 'vi' installed at the very least, so use
# that in the aliases...
else
	export VISUAL=vi
	export EDITOR=vi
	[[ $(type -t vi) == "alias" ]] && unalias vi
	alias vim='vi'
	alias nvim='vi'

fi
