require 'coveralls'
Coveralls.wear!

require 'json'
require 'minitest/autorun'
require 'rspec/mocks'
require 'pry' if ENV['DEBUG']

LIB_PATH = Pathname.new(__FILE__).realpath.dirname.parent.join('lib').to_s
$LOAD_PATH.unshift(LIB_PATH)

require 'zq'
require_relative 'support/minitest'
require_relative 'support/redis'

class ZQTestCase < Minitest::Test
  include MiniTest::RSpecMocks

  def assert_source_read_sequence(expected_items, source)
    seq = []
    while item = source.read_next
      seq << item
    end
    assert_equal expected_items, seq + [nil]
  end
end

class TestSource
  def transactional?
    false
  end

  def initialize(contents)
    @contents = contents
  end

  def read_next
    @contents.shift
  end
end

module OrchestraTestCaseMixin
  def setup
    super
    ZQ.autoregister_orchestra!
  end

  def create_source(contents)
    TestSource.new(contents)
  end
end
