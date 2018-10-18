export PATH=/usr/local/bin:$PATH
export EDITOR=emacs
alias l='ls'
alias dir='clear; pwd; ls .'
alias ll='ls -al'

# OSX
if [ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]; then
   source /usr/local/opt/chruby/share/chruby/chruby.sh
fi

# Linux
if [ -f /usr/share/chruby/chruby.sh ]; then
   source /usr/share/chruby/chruby.sh
fi

chruby 2.4

# It's go time
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
[ -d "/Users/acoyle/github/8b/bin" ] && export PATH="/Users/acoyle/github/8b/bin:$PATH"
export GO15VENDOREXPERIMENT=1

PERL_MB_OPT="--install_base \"/Users/acoyle/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/acoyle/perl5"; export PERL_MM_OPT;

export PS1=" [\h] \W > "
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export GITHUB_HOST=git.enova.com
