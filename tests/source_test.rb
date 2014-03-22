require 'test_helper'
require "redis"


class STDINTestCase < ZQTestCase
  def test_read_next
    file = StringIO.new
    file.puts 'line1'
    file.puts 'line2'
    file.rewind
    source = ZQ::Sources::IOSource.new file
    assert_source_read_sequence ['line1', 'line2', nil], source
  end
end

class RedisLPOPTestCase < ZQTestCase
  def test_read_next
    client = Redis.new
    listname = "test"
    client.rpush listname, "line1"
    client.rpush listname, "line2"
    source = ZQ::Sources::RedisLPOP.new client, listname
    assert_source_read_sequence ['line1', 'line2', nil], source
  end
  def teardown
    super
    Redis.new.flushdb
  end
end
