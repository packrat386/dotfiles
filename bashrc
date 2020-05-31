export PATH=/usr/local/bin:$PATH
export EDITOR=emacs

alias l='ls'
alias ll='ls -al'

# OSX
if [ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
   source /usr/local/opt/chruby/share/chruby/chruby.sh
fi

# Linux
if [ -f /usr/share/chruby/chruby.sh ]; then
   source /usr/share/chruby/chruby.sh
fi

# It's go time
export GOPATH=~/go
export GOPRIVATE=git.enova.com
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export PS1=" [\h] \W > "
