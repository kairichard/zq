require 'test_helper'

class TransactionalSource < TestSource
  include ZQ::Sources::TransactionalMixin
end

class SourceTransactionTestCase < ZQTestCase
  include OrchestraTestCaseMixin
  include RedisTestCaseMixin

  def setup
    super
    @source = TransactionalSource.new(['data'])
    @orc = ZQ.create_orchestra
    @composer = double('composer')
  end

  def test_data_is_put_back_into_source_when_composer_raises_error
    expect(@composer).to receive(:compose).and_raise(RuntimeError)
    expect(@source).to receive(:rollback).with('data')
    @orc.source(@source)
    @orc.compose_with(@composer)
    @orc.new.process_until_exhausted
  end

  def test_data_is_committed_when_composing_succeeded
    expect(@composer).to receive(:compose)
    expect(@source).to receive(:commit).with('data')
    @orc.source(@source)
    @orc.compose_with(@composer)
    @orc.new.process_until_exhausted
  end
end

class RedisTransactionTestCase < ZQTestCase
  include OrchestraTestCaseMixin
  include RedisTestCaseMixin

  def setup
    super
    listname = 'test'
    client.rpush listname, 'line1'
    @composer = double('composer')
    @orc = ZQ.create_orchestra
  end

  def test_rollback
    expect(@composer).to receive(:compose).and_raise(RuntimeError)
    source = ZQ::Sources::RedisTransactionalQueue.new(client, 'test')
    @orc.source(source)
    @orc.compose_with(@composer)
    @orc.new.process_until_exhausted
    assert_equal source.read_next, 'line1'
  end

  def test_commit
    expect(@composer).to receive(:compose).and_return(true)
    source = ZQ::Sources::RedisTransactionalQueue.new(client, 'test')
    @orc.source(source)
    @orc.compose_with(@composer)
    @orc.new.process_until_exhausted
    assert_equal source.read_next, nil
  end
end
