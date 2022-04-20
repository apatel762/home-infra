if command -v apps-maintain &>/dev/null; then
	# If not running interactively, don't do anything
	if [[ $- != *i* ]]; then
		:
	else
		apps-maintain
	fi
fi
