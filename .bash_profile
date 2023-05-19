# PATH general use
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# fancy ls
alias ls="ls -Gh"

# fancy whoami
_HOST="$HOSTNAME"
alias whoami="whoami && echo @$_HOST"

# terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git branch in bash prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# bash prompt
export PS1="\u ✨ \[\e[36;40m\]\W\[\e[33;1m\]\$(parse_git_branch) \[\e[32;1m\]>\[\e[0m\] "

# my shortcuts
alias GH="cd ~/github"
alias BB="cd ~/bitbucket"
alias CHEAT="open https://github.com/laurengarcia/cheatsheets"

# check open ports
alias open-ports="lsof -i -P -n | grep LISTEN"
