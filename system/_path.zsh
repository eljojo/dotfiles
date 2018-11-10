export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# export PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
# export PATH="/usr/local/share/npm/bin:$DOTFILES/bin:$PATH"


# if [[ -a /usr/local/opt/ruby/bin ]]
# then
#   export PATH="/usr/local/opt/ruby/bin:$PATH"
# fi

if [[ -a /usr/local/go || -a /usr/local/opt/go/libexec ]]
then
  export GOROOT=/usr/local/go

  if [[ -a /usr/local/opt/go/libexec ]]
  then
    export GOROOT=/usr/local/opt/go/libexec
  fi

  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.bin
fi

