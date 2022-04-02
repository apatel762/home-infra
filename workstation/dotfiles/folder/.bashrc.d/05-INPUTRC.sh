export INPUTRC="$HOME/.config/.inputrc"
if [ -f "$INPUTRC" ] ; then
    # ensure that the current INPUTRC is used in the terminal sesh
    # if it's present
    bind -f "$INPUTRC"
fi
