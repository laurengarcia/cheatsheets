# PATH general use
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/bin/python3:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# Silence MacOS deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Node NVM version mgmt
# nvm -v
# nvm ls
# nvm use v20.0.0
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Python3
export PYTHON=/opt/homebrew/bin/python3
alias python='/opt/homebrew/bin/python3'

# fancy ls
alias ls="ls -Gh"

# fancy whoami
_HOST="$HOSTNAME"
alias whoami="whoami && echo @$_HOST"

# terminal colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# git branch in prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# bash prompt
export PS1="\u ✨ \[\e[36;40m\]\W\[\e[33;1m\]\$(parse_git_branch) \[\e[32;1m\]>\[\e[0m\] "

# my dir shortcuts
alias SHORT="cat ~/github/cheatsheets/index.txt"
alias CHEAT="open https://github.com/laurengarcia/cheatsheets"
alias GH="cd ~/github"
alias NPM="npm root -g"

# check for open ports
alias check-ports="lsof -i -P -n | grep LISTEN"
