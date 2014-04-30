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

alias sshhomer='ssh homer.eljojo.net'
alias sshelmo='ssh elmo.eljojo.net'

alias deploy='git push origin && cap deploy'
alias deploy_and_migrate='deploy && sleep 3 && cap deploy:stop && sleep 3 && cap deploy:migrate && sleep 3 && cap deploy:start && say "deployed and migrated"'
alias psql_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias psql_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias redis.start='redis-server /usr/local/etc/redis.conf'
alias mongo.start='/usr/local/opt/mongodb/bin/mongod --config /usr/local/etc/mongod.conf --fork'
alias es.start='elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml'
