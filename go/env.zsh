# if command -v go &> /dev/null
# then
#   # export GOPATH="$HOME/.go/"
#   # mkdir -p $GOPATH
#   # export PATH=$PATH:$(go env GOPATH)/bin
# fi

# if [[ -a /usr/local/go || -a /usr/local/opt/go/libexec ]]
if command -v go &> /dev/null
then
  export GOROOT=/usr/local/go

  if [[ -a /usr/local/opt/go/libexec ]]
  then
    export GOROOT=/usr/local/opt/go/libexec
  fi

  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# if command -v loon &> /dev/null
# then
#   . "$HOME/loon/shellrc"
# fi

