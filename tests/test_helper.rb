require 'json'
require 'ostruct'
require 'minitest/autorun'
require 'rspec/mocks'
require 'pry' if ENV['DEBUG']

require 'zq'

class Object
  # remove Minitest's stub method so RSpec's version on BasicObject will work
  if self.method_defined?(:stub) && !defined?(removed_minitest)
    remove_method :stub
    removed_minitest = true
  end
end

module Minitest
  module RSpecMocks
    include RSpec::Mocks::ExampleMethods unless ::RSpec::Mocks::Version::STRING < "3"
    def before_setup
      if ::RSpec::Mocks::Version::STRING < "3"
        ::RSpec::Mocks.setup(self)
      else
        ::RSpec::Mocks.setup
      end
      super
    end

    def after_teardown
      begin
        ::RSpec::Mocks.verify
      ensure
        ::RSpec::Mocks.teardown
      end
      super
    end
  end
end

class ZQTestCase < Minitest::Test
  include MiniTest::RSpecMocks
  def get_digester
    TestDigester.new
  end

  def get_repo
    TestRepo.instance
  end

  def get_data_source
    TestSource.instance
  end

  def assert_source_read_sequence(expected_items, source)
    seq = []
    item =
    while item = source.read_next
      seq << item
    end
    assert_equal expected_items, seq + [nil]
  end

  def teardown
    get_repo.clear
    get_data_source.clear
  end
end

class TestSource
  include ZQ::DataSource
end

class TestRepo
  include Singleton
  def initialize
    @contents = []
  end

  def all
    @contents
  end

  def create(e)
    @contents << e
  end

  def clear
    @contents = []
  end
end

class EchoComposer
  def compose(raw_data, composite = nil)
    raw_data
  end
end

class TestJsonComposer
  def compose(raw_data, composite = nil)
    OpenStruct.new JSON.parse(raw_data)
  end
end

class TestPersitanceComposer
  def compose(raw_data, composite = nil)
    TestRepo.instance.create composite
  end
end

module OrchestraTestCaseMixin
  def setup
    super
    ZQ.autoregister_orchestra!
    data_source = get_data_source
    value = '{"key": "value"}'
    data_source.insert value
  end

  def teardown
    super
    ZQ.reset!
  end
end
