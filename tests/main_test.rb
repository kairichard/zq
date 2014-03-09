require 'test_helper'

class DataSourceTestCase < ZiwTestCase
  def test_can_read_data_from_source
    data_source = get_data_source
    value = '{"key": "value"}'
    data_source.insert value
    assert data_source.read_next == value
  end

  def test_source_can_exhauste
    data_source = get_data_source
    value = '{"key": "value"}'
    data_source.insert value
    assert data_source.read_next == value
    assert data_source.read_next.nil?
  end
end

class OrchestraTestCase < ZiwTestCase
  def build_orchestra
    data_source = get_data_source
    value = '{"key": "value"}'
    data_source.insert value
    @o = TestOrchestra.new
  end

  def test_orchestra_process_data
    build_orchestra
    @o.process_until_exhausted
    assert_instance_of Array, get_repo.all
    assert_equal 1, get_repo.all.length
  end

  def test_module_knows_all_orchestras
    assert_equal [TestOrchestra], ZQ.known_orchestras
  end

  def test_orchestras_do_not_autoregister
    ZQ.stop_autoregister_orchestra!
    klass = Object.const_set("AnotherOrc",Class.new)
    klass.class_exec do
      include ZQ::Orchestra
    end
    assert ZQ.known_orchestras == [TestOrchestra]
  end
end
