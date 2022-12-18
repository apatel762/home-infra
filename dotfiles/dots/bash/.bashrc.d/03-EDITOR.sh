#!/usr/bin/env bash

function _ensure_appimage_extracted() {
	if [ -f /run/.containerenv ] && [ -f /run/.toolboxenv ]; then
		# you cannot run this function from a toolbox container
		# because we won't be able to determine the AppImage version
		# for comparison with the extracted binary version (FUSE
		# mounting doesn't work within toolboxes)
		return 1
	fi

	# unpack the vars passed in to the function
	local BINARY_NAME
	BINARY_NAME="$1"
	local APPIMAGE_NAME
	APPIMAGE_NAME="$2"

	local LOCAL_BIN
	LOCAL_BIN="$HOME/.local/bin"
	mkdir -p "$LOCAL_BIN"

	local EXPECTED_BINARY
	EXPECTED_BINARY="$LOCAL_BIN/$BINARY_NAME"

	local EXPECTED_APPIMAGE
	EXPECTED_APPIMAGE="$LOCAL_BIN/$APPIMAGE_NAME"

	# ensure that we re-extract the Neovim AppImage if AppImage version is
	# different to the extracted binary. We make sure of this by deleting
	# the extracted binary if there's a difference in the version output,
	# and the code down below should detect that it needs to re-extract
	# stuff.
	#
	# version mismatch checking is disabled when you are in a toolbox
	# because we can't check the .AppImage version without having FUSE
	# installed, and it isn't installed in a container.
	if [ -e "$EXPECTED_BINARY" ] && [ -e "$EXPECTED_APPIMAGE" ]; then
		local APPIMAGE_VERSION
		APPIMAGE_VERSION="$("$EXPECTED_APPIMAGE" --version)"
		local BINARY_VERSION
		BINARY_VERSION="$("$EXPECTED_BINARY" --version)"

		if [[ "$APPIMAGE_VERSION" != "$BINARY_VERSION" ]]; then
			echo "Version mismatch between $APPIMAGE_NAME and $BINARY_NAME binary."
			if [ ! -f /run/.containerenv ] && [ ! -f /run/.toolboxenv ]; then
				rm -fv "$EXPECTED_BINARY"
			else
				echo "Cannot resolve version mismatch between $APPIMAGE_NAME and $BINARY_NAME binary from within a toolbox. Try again from a host terminal."
				return 1
			fi
		fi
	fi

	# if the symlink is broken, ensure that the target is removed
	# ...and remove the squashfs root while we're at it (if it's there)
	if [ ! -e "$EXPECTED_BINARY" ]; then
		if [ ! -f /run/.containerenv ] && [ ! -f /run/.toolboxenv ]; then
			rm -fv "$EXPECTED_BINARY"
			rm -rf "$LOCAL_BIN/$BINARY_NAME-root"
		else
			echo "Symlink between $APPIMAGE_NAME and $BINARY_NAME binary is broken, but cannot resolve from a toolbox container. Try again from a host terminal."
			return 1
		fi
	fi 

	if ! command -v "$BINARY_NAME" &>/dev/null \
		&& [ -f "$EXPECTED_APPIMAGE" ]; then
		# if we are in here, we have the AppImage in the local bin and
		# we DON'T have the binary, so here, we need to extract the binary
		# from the AppImage and create a symlink
		if [ ! -f /run/.containerenv ] && [ ! -f /run/.toolboxenv ]; then
			(
				echo "Creating physical $APPIMAGE_NAME alias"
				cd "$LOCAL_BIN" || return 1
				./"$APPIMAGE_NAME" --appimage-extract &>/dev/null

				# rename the fs root folder
				mv squashfs-root "$BINARY_NAME"-root

				# create symlink
				ln -s "$BINARY_NAME"-root/usr/bin/"$BINARY_NAME" "$BINARY_NAME"
			)
		else
			echo "Cannot resolve version mismatch between $APPIMAGE_NAME and $BINARY_NAME binary from within a toolbox. Try again from a host terminal."
			return 1
		fi
	fi
}

# using the Neovim AppImage on my workstation, so if it's present, this
# init script will extract the AppImage and create the relevant
# symlinks to make it all work (even when inside of a toolbox, where
# you can't use FUSE mounts).
_ensure_appimage_extracted "nvim" "nvim.AppImage"

# if we've got 'nvim' then prioritise that over the other stuff
if command -v nvim &>/dev/null; then
	export VISUAL=nvim
	export EDITOR=nvim
	alias vi='vim'
	alias vim='nvim'
	[[ $(type -t nvim) == "alias" ]] && unalias nvim


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
