# PATH general use
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/lib/node_modules/phantomjs/lib/phantom/bin/phantomjs:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# bash prompt
export PS1="🏄‍♀️☕️✌️  \u  \[\e[36;40m\]\W\[\e[33;1m\]\$(parse_git_branch)  \[\e[32;1m\]>>\[\e[0m\] "

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

# my shortcuts
alias GH="cd ~/github"
alias BB="cd ~/bitbucket"

_CHEATDIR="~/github/cheatsheets"
alias CHEAT="cat $_CHEATDIR/index.txt"
alias SCHEAT="sublime $_CHEATDIR"
alias LSCHEAT="ls $_CHEATDIR"
alias CDCHEAT="cd $_CHEATDIR"
alias ND="cat $_CHEATDIR/node-debug.txt"
alias BASH="cat $_CHEATDIR/bash.txt"

_LOCUS='const locus = require\(\`/usr/local/lib/node_modules/locus\`\)' # <-- global npm locus location
alias LOCUS="echo $_LOCUS\; eval\(locus\)"
_NPM="global npm modules location: /usr/local/lib/node_modules"
alias NPM="echo $_NPM"
