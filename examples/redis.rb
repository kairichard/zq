require 'redis'
require 'zq'

CLIENT = Redis.new(db: 1)

class RedisPull
  include ZQ::Orchestra
  source ZQ::Sources::RedisLPOP.new(CLIENT, "incoming")
  compose_with ZQ::Composer::Echo.new
  desc "reads from redis:key:'incoming' and prints to stdout"
end
