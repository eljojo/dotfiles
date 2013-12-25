# rehash shims
rbenv rehash 2>/dev/null

# there was a rbenv thing here.
if [ "$(uname -s)" = "Darwin" ]
then
  export RUBY_GC_MALLOC_LIMIT=60000000
  export RUBY_GC_HEAP_FREE_SLOTS=200000
fi
