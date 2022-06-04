if command -v desktop-maintain &>/dev/null; then
	# If not running interactively, don't do anything
	if [[ $- != *i* ]]; then
		:
	else
		desktop-maintain
	fi
fi
