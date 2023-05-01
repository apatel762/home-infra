#!/usr/bin/env bash

alias fp='git fetch --all --prune && git pull --rebase --autostash'

function __delete_merged_branches() {
    git fetch -p
    for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
        git branch -D "$branch";
    done
}
alias dmb=__delete_merged_branches
