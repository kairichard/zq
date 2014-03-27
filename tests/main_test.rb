require 'test_helper'

class OrchestraTestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_process_data
    orc = ZQ.create_orchestra do
      source TestSource.instance
      compose_with TestJsonComposer.new, TestPersitanceComposer.new
    end
    orc.new.process_until_exhausted
    assert_instance_of Array, get_repo.all
    assert_equal 1, get_repo.all.length
  end
end

class OrchestraSourceAPITestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_source
    orc = ZQ.create_orchestra
    source = double("source")
    expect(source).to receive(:read_next).and_return(nil)
    orc.source source
    orc.add_composer(Object.new)
    orc.new.process_until_exhausted
  end
end

class OrchestraComposeApiTestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_bare_bones
    orc = ZQ.create_orchestra
    orc.source = {}
    assert_raises NoComposerProvided do
      orc.new.process_until_exhausted
    end
  end

  def test_orchestra_bare_bones
    orc = ZQ.create_orchestra
    assert_raises NoSourceProvided do
      orc.new.process_until_exhausted
    end
  end

  def test_orchestra_single_composer
    composer = double("composer")
    expect(composer).to receive(:compose).with("{\"key\": \"value\"}", nil).and_return(nil)

    orc = ZQ.create_orchestra
    orc.source TestSource.instance
    orc.add_composer composer
    orc.new.process_until_exhausted
  end

  def test_orchestra_composer_chain
    composer1 = double("composer1")
    expect(composer1).to receive(:compose).with("{\"key\": \"value\"}", nil).and_return(:value)
    composer2 = double("composer2")
    expect(composer2).to receive(:compose).with("{\"key\": \"value\"}", :value).and_return(nil)

    orc = ZQ.create_orchestra
    orc.source TestSource.instance
    orc.compose_with composer1, composer2
    orc.new.process_until_exhausted
  end
end

class OrchestraRegistrationTestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestras_do_not_autoregister
    ZQ.stop_autoregister_orchestra!
    ZQ.create_orchestra
    assert_equal [], ZQ.live_orchestras
  end

  def test_orchestras_can_be_registered_later
    ZQ.stop_autoregister_orchestra!
    klass = ZQ.create_orchestra
    ZQ.register_orchestra klass
    assert_equal [klass], ZQ.live_orchestras
  end

  def test_orchestras_can_be_deregistered
    klass = ZQ.create_orchestra
    ZQ.deregister_orchestra klass
    assert_empty ZQ.live_orchestras
  end
end
