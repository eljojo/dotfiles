# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

alias p='ping 8.8.8.8'
alias n='netstat -a -e -e -p -A inet'

alias chmdo=chmod
alias sl=ls
alias icfonfig=ifconfig
alias ifocnfig=ifconfig
alias mann=man
alias act=cat
alias cart=cat
alias grpe=grep
alias gpre=grep

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

alias sshhomer='ssh homer.eljojo.net -p123'
alias psql_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias psql_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias redis.server='redis-server /usr/local/etc/redis.conf'
