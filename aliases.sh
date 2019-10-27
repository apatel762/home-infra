# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Quick config editing
alias vimrc='vi ~/.vimrc'
alias bashrc='vi ~/.bashrc'
alias gitconfig='vi ~/.gitconfig'

alias dotfiles='pushd ~/dotfiles'

alias c='clear'

alias dt='cd ~/Desktop/'
alias doc='cd ~/Documents/'
alias dl='cd ~/Downloads/'

alias bp='echo "source ~/.bashrc" && source ~/.bashrc'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tor=(dotfiles && ./scripts/run_tor.sh; popd)
