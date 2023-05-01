#!/usr/bin/env bash

# append to history instead of deleting
shopt -s histappend

# checks term size when bash regains control
shopt -s checkwinsize

# expand aliases
shopt -s expand_aliases

# save multiline cmds as single line in hist
shopt -s cmdhist
