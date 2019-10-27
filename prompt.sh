# PS1 - get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ] 
  then
    echo "[${BRANCH}]"
  else
    echo "" 
  fi
}

# PS1 - Get the status code of the last command 
function nonzero_return() {
  RETVAL=$?
  [ $RETVAL -ne 0 ] && echo "$RETVAL"
}

PS1="\n"
PS1=$PS1"\u[\\$\[\e[31m\]\`nonzero_return\`\[\e[m\]] \[\e[32m\]\w\[\e[m\] \[\e[36m\]\`parse_git_branch\`\[\e[m\]"
PS1=$PS1"\n"

export PS1=$PS1"> "

