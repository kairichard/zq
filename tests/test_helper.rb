require 'test/unit'
require 'ostruct'
require 'json'
require 'pry'
require 'zimtw'

class ZiwTestCase < Test::Unit::TestCase
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
  end
end

class TestDigester
  def digest data
    OpenStruct.new JSON.parse(data)
  end
end

class TestRepo
  include Zimtw::Repository
end

class TestSource
  include Zimtw::DataSource
end

class TestOrchestra
  include Zimtw::Orchestra
  source TestSource.instance
  repository TestRepo.instance
  digester TestDigester.new
end

