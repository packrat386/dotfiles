export PATH=/usr/local/bin:$PATH
export EDITOR=emacs
unset COLORTERM

alias l='ls'
alias ll='ls -al'

# brew env vars
if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# OSX
if [ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
   source /usr/local/opt/chruby/share/chruby/chruby.sh
fi

if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
fi

# Linux
if [ -f /usr/local/share/chruby/chruby.sh ]; then
   source /usr/local/share/chruby/chruby.sh
fi

# It's go time
export GOPATH=~/go
export GOPRIVATE=git.enova.com
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export PATH=$PATH:~/bin

[ -s ~/github/sk/sk.sh ] && \. ~/github/sk/sk.sh # load sk

export PS1="  [\h] \W > "

# load employer specific stuff last
[ -s ~/.employer/bashrc ] && \. ~/.employer/bashrc
