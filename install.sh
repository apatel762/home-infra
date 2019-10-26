# overwrite current bashrc with one line that sources the custom one
echo "[ -f ~/dotfiles/.bashrc ] && source ~/dotfiles/.bashrc" > ~/.bashrc

# create an inputrc
[ -f ~/dotfiles/.inputrc ] && cat ~/dotfiles/.inputrc > ~/.inputrc
