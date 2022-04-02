export PYENV_ROOT="$HOME/.local/share/.pyenv"
prepend_to_path "$PYENV_ROOT/bin"
prepend_to_path "$PYENV_ROOT/shims" # alternative to `eval "$(pyenv init --path)"`

if command -v pyenv &>/dev/null; then
    # start pyenv now that the PATH variables are set
    # but only if we have pyenv installed
    eval "$(pyenv init -)"
fi
