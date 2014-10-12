# there was a rbenv thing here.
if [ "$(uname -s)" = "Darwin" ]
then
  export RUBY_GC_MALLOC_LIMIT=60000000
  export RUBY_GC_HEAP_FREE_SLOTS=200000
fi

# init according to man page
if (( $+commands[rbenv] ))
then
  eval "$(rbenv init -)"
fi
