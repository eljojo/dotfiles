# if command -v go &> /dev/null
# then
#   # export GOPATH="$HOME/.go/"
#   # mkdir -p $GOPATH
#   # export PATH=$PATH:$(go env GOPATH)/bin
# fi

# if [[ -a /usr/local/go || -a /usr/local/opt/go/libexec ]]
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
