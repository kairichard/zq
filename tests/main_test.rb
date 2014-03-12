require 'test_helper'

class OrchestraTestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_process_data
    orc = create_orchestra do
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
    orc = create_orchestra
    orc.source @source
    orc.new.process_until_exhausted
    @source.verify
  end
end

class OrchestraComposeApiTestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_single_composer
    @composer = Minitest::Mock.new
    @composer.expect :compose, nil, ["{\"key\": \"value\"}", nil]
    orc = create_orchestra
    orc.source TestSource.instance
    orc.add_composer @composer
    orc.new.process_until_exhausted
    @composer.verify
  end

  def test_orchestra_composer_chain
    @composer1 = Minitest::Mock.new
    @composer2 = Minitest::Mock.new

    @composer1.expect :compose, :return_value, ["{\"key\": \"value\"}", nil]
    @composer2.expect :compose, nil, ["{\"key\": \"value\"}", :return_value]
    orc = create_orchestra
    orc.source TestSource.instance
    orc.add_composer @composer1
    orc.add_composer @composer2
    orc.new.process_until_exhausted
    @composer1.verify
    @composer2.verify
  end
end


class OrchestraRegistrationTestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_orchestras_do_not_autoregister
    ZQ.stop_autoregister_orchestra!
    create_orchestra
    assert_equal [], ZQ.live_orchestras
  end

  def test_orchestras_can_be_registered_later
    ZQ.stop_autoregister_orchestra!
    klass = create_orchestra
    ZQ.register_orchestra klass
    assert_equal [klass], ZQ.live_orchestras
  end

  def test_orchestras_can_be_deregistered
    klass = create_orchestra
    ZQ.deregister_orchestra klass
    assert_empty ZQ.live_orchestras
  end
end
