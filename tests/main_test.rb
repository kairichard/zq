require_relative 'test_helper'

class DigestTestCase < ZiwTestCase
  def test_digester_takes_json_returns_some_sort_of_representation
    digester = get_digester
    entity = digester.digest '{"key": "value"}'
    refute entity.nil?
  end
end

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
    assert get_repo.all.is_a?(Array)
    assert get_repo.all.length == 1
  end

  def test_module_knows_all_orchestras
    assert Zimtw.known_orchestras == [TestOrchestra]
  end
end
