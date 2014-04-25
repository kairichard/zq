require 'redis'
require 'zq'

CLIENT = Redis.new(db: 1)

class RedisFanout
  include ZQ::Orchestra
  source ZQ::Sources::RedisLPOP.new(CLIENT, "incoming")
  compose_with(
    ZQ::Composer::JsonParse.new,
    ZQ::Composer::UUID4Hash.new,
    ZQ::Composer::JsonDump.new,
    ZQ::Composer::Tee.new($stdout),
    ZQ::Composer::RedisPublish.new("data", CLIENT)
  )

  desc "Read transform publish"
end
