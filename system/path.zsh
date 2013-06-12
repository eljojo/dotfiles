export PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
export PATH="./bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:/usr/local/share/npm/bin:/usr/local/sbin:$DOTFILES/bin:$PATH"

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

if [[ -a /usr/local/opt/ruby/bin ]]
then
  export PATH="/usr/local/opt/ruby/bin:$PATH"
fi
