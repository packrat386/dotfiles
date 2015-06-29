export PATH=/usr/local/bin:$PATH
export EDITOR=emacs
alias l='ls'
alias dir='pwd; ls .'
alias ll='ls -al'

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 2.2.2

# It's go time
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
[ -d "/Users/acoyle/github/8b/bin" ] && export PATH="/Users/acoyle/github/8b/bin:$PATH"

PERL_MB_OPT="--install_base \"/Users/acoyle/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/acoyle/perl5"; export PERL_MM_OPT;
