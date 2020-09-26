# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="rkj"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="blinks"
ZSH_THEME="spaceship"

DISABLE_AUTO_TITLE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker-compose)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$PATH:$HOME/.rvm/bin"

#export SPACESHIP_BATTERY_SHOW="false"
export SPACESHIP_DOCKER_SHOW="false"
export SPACESHIP_RUBY_SHOW="false"
export SPACESHIP_ELM_SHOW="false"
export SPACESHIP_ELIXIR_SHOW="false"
export SPACESHIP_XCODE_SHOW_LOCAL="false"
export SPACESHIP_SWIFT_SHOW_LOCAL="false"
export SPACESHIP_GOLANG_SHOW="false"
export SPACESHIP_PHP_SHOW="false"
export SPACESHIP_RUST_SHOW="false"
export SPACESHIP_HASKELL_SHOW="false"
export SPACESHIP_JULIA_SHOW="false"
export SPACESHIP_PYENV_SHOW="false"
export SPACESHIP_NODE_SHOW="false"
export SPACESHIP_EXIT_CODE_SHOW="true"

alias showports='lsof -PiTCP -sTCP:LISTEN'

alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

export AWS_PAGER=""
