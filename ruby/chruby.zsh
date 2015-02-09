# there was a rbenv thing here.
if [ "$(uname -s)" = "Darwin" ]
then
  export RUBY_GC_MALLOC_LIMIT=60000000
  export RUBY_GC_HEAP_FREE_SLOTS=200000
fi

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# loading the latest ruby
chruby ruby
