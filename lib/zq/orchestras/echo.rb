require 'zq/orchestra'
require 'zq/sources/io'
require 'zq/composers/io'

class Echo
  include ZQ::Orchestra
  source ZQ::Sources::IOSource.new $stdin
  compose_with ZQ::Composer::Echo.new
  desc 'prints contents from stdin'
end

