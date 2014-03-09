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
  include OrchestraTestCaseMixin
  def test_orchestra_process_data
    orc = create_orchestra "FooBar" do
      source TestSource.instance
      compose_with [
        TestJsonComposer,
        TestPersitanceComposer,
      ]
    end
    orc.new.process_until_exhausted
    assert_instance_of Array, get_repo.all
    assert_equal 1, get_repo.all.length
  end

  def test_orchestras_do_not_autoregister
    ZQ.stop_autoregister_orchestra!
    create_orchestra "Foo1"
    assert_equal [], ZQ.known_orchestras
  end

  def test_orchestras_can_be_registered_later
    ZQ.stop_autoregister_orchestra!
    klass = create_orchestra "Foo2"
    ZQ.register_orchestra klass
    assert_equal [klass], ZQ.known_orchestras
  end

  def test_orchestras_can_be_deregistered
    klass = create_orchestra "Foo3"
    ZQ.deregister_orchestra klass
    assert_empty ZQ.known_orchestras
  end
end
