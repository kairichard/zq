require 'redis'

module RedisTestCaseMixin
  def setup
    super
    @client = Redis.new
  end

  def client
    @client
  end

  def teardown
    super
    client.flushdb
  end
end
