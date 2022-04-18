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
