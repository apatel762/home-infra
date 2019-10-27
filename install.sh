# create an inputrc
[ -f ~/dotfiles/.inputrc ] && cat ~/dotfiles/.inputrc > ~/.inputrc

# source the shell scripts in this dotfiles folder
echo "[ -f dotfiles/aliases.sh ] && source dotfiles/aliases.sh" > ~/.bashrc
echo "[ -f dotfiles/default.sh ] && source dotfiles/default.sh" >> ~/.bashrc
echo "[ -f dotfiles/prompt.sh ] && source dotfiles/prompt.sh" >> ~/.bashrc
