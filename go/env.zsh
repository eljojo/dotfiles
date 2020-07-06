if command -v COMMAND &> /dev/null
then
  export GOPATH="$HOME/.go/"
  mkdir -p $GOPATH
  export PATH=$PATH:$(go env GOPATH)/bin
fi

