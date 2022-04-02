# I want to use `bat` as the manpager if it's installed so that I get
# syntax highlighting on manpages. Also, since it uses the same keys as
# less, there's no reason not to use it if you have it.

if command -v bat &>/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi
