if [ -f /run/.containerenv ] && [ -f /run/.toolboxenv ]; then
	if command -v bin-maintain &>/dev/null; then
		# If not running interactively, don't do anything
		if [[ $- != *i* ]]; then
			:
		else
			bin-maintain
		fi
	fi
fi