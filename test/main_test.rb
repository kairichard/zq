require 'test_helper'

class OrchestraComposeApiTestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestra_bare_bones
    orc = ZQ.create_orchestra
    assert_raises NoSourceProvided do
      orc.new.process_until_exhausted
    end
  end

  def test_orchestra_single_composer
    composer = double('composer')
    expect(composer).to receive(:compose).with('test_data', nil).and_return(nil)

    orc = ZQ.create_orchestra
    orc.source(create_source(['test_data']))
    orc.add_composer composer
    orc.new.process_until_exhausted
  end

  def test_orchestra_error_in_composer_is_swallowable
    composer = double('composer')
    expect(composer1).to receive(:compose).and_raise(RuntimeError)
    orc = ZQ.create_orchestra
    orc.ignore_errors!
    orc.source(create_source(['test_data']))
    orc.compose_with(composer)
    orc.new.process_until_exhausted
  end

  def test_orchestra_error_in_composer_is_swallowable
    composer = double('composer')
    expect(composer).to receive(:compose).and_raise(RuntimeError)
    source = double('source')
    expect(source).to receive('read_next').and_return('test_data')
    orc = ZQ.create_orchestra
    orc.source(source)
    orc.compose_with(composer)
    assert_raises RuntimeError do
      orc.new.process_until_exhausted
    end
  end

  def test_orchestra_composer_chain
    composer1 = double('composer1')
    expect(composer1).to receive(:compose).with("test_data", nil).and_return(:transformed)
    composer2 = double('composer2')
    expect(composer2).to receive(:compose).with("test_data", :transformed).and_return(nil)

    orc = ZQ.create_orchestra
    orc.source(create_source(['test_data']))
    orc.compose_with(composer1, composer2)
    orc.new.process_until_exhausted
  end
end

class OrchestraRegistrationTestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_orchestras_do_not_autoregister
    ZQ.stop_autoregister_orchestra!
    klass = ZQ.create_orchestra
    refute_includes(ZQ.live_orchestras, klass)
  end

  def test_orchestras_can_be_registered_later
    ZQ.stop_autoregister_orchestra!
    klass = ZQ.create_orchestra
    ZQ.register_orchestra(klass)
    assert_includes(ZQ.live_orchestras, klass)
  end

  def test_orchestras_can_be_deregistered
    klass = ZQ.create_orchestra
    ZQ.deregister_orchestra klass
    refute_includes(ZQ.live_orchestras, klass)
  end
end
