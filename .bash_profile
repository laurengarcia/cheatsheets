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

# Set nvm default
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use 22  # Use Node 22 by default
# Print info
echo "Current Node.js version: $(node -v)"
echo "NVM default version: $(nvm alias default)"

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
alias SH="cat ~/github/cheatsheets/index.txt"
alias CHEAT="open https://github.com/laurengarcia/cheatsheets"
alias GH="cd ~/github"
alias NPM="npm root -g"

# security checks
alias check-ports="lsof -i -P -n | grep LISTEN && lsof -i -P -n | grep ESTABLISHED"
alias check-sign='function _checksign() {
  if [[ -z "$1" ]]; then
    echo -e "\033[1;31m[ERROR]\033[0m Usage: checksign /path/to/binary";
    return 1
  fi
  echo -e "\033[1;34m[INFO]\033[0m ---- Checking codesign details for: \033[1;33m$1\033[0m"
  codesign -vvv --display "$1" && echo -e "\033[1;34m[INFO]\033[0m ---- Display check complete. ----"
  codesign --verify --verbose=4 "$1" && echo -e "\033[1;34m[INFO]\033[0m ---- Verification check complete. ----" || echo -e "\033[1;31m[FAILED]\033[0m Signature verification failed!"
}; _checksign'
