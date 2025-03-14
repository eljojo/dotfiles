alias pi='ping 8.8.8.8'
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

alias youtube-audio="yt-dlp -f 'ba' -x --audio-format mp3"
alias youtube-video='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'

# alias deploy='rake deploy'
# alias stage='git push --force staging HEAD:master'
# alias deploy_and_migrate='deploy && dokku run rake db:migrate'

if [[ -d "/usr/local/var/postgres" ]]; then
  alias psql_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  alias psql_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
fi

if [[ -f "/usr/local/etc/redis.conf" ]]; then
  alias redis.start='redis-server /usr/local/etc/redis.conf'
fi

# alias mongo.start='/usr/local/opt/mongodb/bin/mongod --config /usr/local/etc/mongod.conf --fork'
# alias es.start='launchctl load /usr/local/opt/elasticsearch/homebrew.mxcl.elasticsearch.plist'
# alias etcd.start='launchctl load /usr/local/opt/etcd/homebrew.mxcl.etcd.plist'
# alias rmq.start='launchctl load /usr/local/opt/rabbitmq/homebrew.mxcl.rabbitmq.plist'
