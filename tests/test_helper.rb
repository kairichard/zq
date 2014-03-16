require 'json'
require 'ostruct'
require 'minitest/autorun'
require 'rr'
require 'pry' if ENV['debug']

require 'zq'

class ZiwTestCase < Minitest::Test
  def get_digester
    TestDigester.new
  end

  def get_repo
    TestRepo.instance
  end

  def get_data_source
    TestSource.instance
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
