#!/usr/bin/env bash

function __cd_to_git_repos_folder() {
    if ! command -v ghq &>/dev/null; then
        echo "install ghq first"
        return 1
    fi
    if ! command -v fzf &>/dev/null; then
        echo "install fzf first"
        return 1
    fi
    cd "$(ghq list -p | fzf)"
}
alias proj=__cd_to_git_repos_folder

# add auto-completion for ghq if it's present
if command -v ghq &>/dev/null; then
    function _ghq () {
        local cur prev words cword
        _init_completion || return

        case $cword in
        1)
            COMPREPLY=( $(compgen -W "get list" -- $cur) );;
        2)
            case $prev in
            get)
                COMPREPLY=( $(compgen -W "$(ghq list --unique)" -- $cur) );;
            list)
                COMPREPLY=( $(compgen -W "$(ghq list)" -- $cur) );;
            esac;;
        *)
            COMPREPLY=( $(compgen -W "$(ls)" -- $cur) );;
        esac
      }
    complete -F _ghq ghq
fi
