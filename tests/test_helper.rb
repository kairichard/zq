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
  def assert_source_read_sequence(expected_items, source)
    seq = []
    item =
    while item = source.read_next
      seq << item
    end
    assert_equal expected_items, seq + [nil]
  end
end

module OrchestraTestCaseMixin
  def setup
    super
    ZQ.autoregister_orchestra!
  end

  def create_source(contents)
    contents = contents + [nil]
    source = double("source")
    expect(source).to receive(:read_next).exactly(contents.length).times.and_return(*contents)
    source
  end

  def teardown
    super
    ZQ.reset!
  end
end
