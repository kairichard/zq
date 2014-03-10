require 'test_helper'

class OrchestraTestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_process_data
    orc = create_orchestra "FooBar" do
      source TestSource.instance
      compose_with [
        TestJsonComposer.new,
        TestPersitanceComposer.new,
      ]
    end
    orc.new.process_until_exhausted
    assert_instance_of Array, get_repo.all
    assert_equal 1, get_repo.all.length
  end
end

class OrchestraSourceAPITestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_source
    @source = Minitest::Mock.new
    @source.expect :read_next, nil
    orc = create_orchestra "SourceFooBar"
    orc.source @source
    orc.new.process_until_exhausted
    @source.verify
  end
end


class OrchestraRegistrationTestCase < ZiwTestCase
  include OrchestraTestCaseMixin

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
