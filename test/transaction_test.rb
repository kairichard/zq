require 'test_helper'

class TransactionalSource < TestSource
  include ZQ::Sources::TransactionalMixin
end

class SourceTransactionTestCase < ZQTestCase
  include OrchestraTestCaseMixin
  include RedisTestCaseMixin

  def test_data_is_put_back_into_source_when_composer_raises_error
    composer = double('composer')
    source = TransactionalSource.new(['data'])
    expect(composer).to receive(:compose).and_raise(RuntimeError)
    expect(source).to receive(:rollback).with('data')
    orc = ZQ.create_orchestra
    orc.source(source)
    orc.compose_with(composer)
    orc.new.process_until_exhausted
  end

  def test_data_is_committed_when_composing_succeeded
    composer = double('composer')
    source = TransactionalSource.new(['data'])
    expect(composer).to receive(:compose)
    expect(source).to receive(:commit).with('data')
    orc = ZQ.create_orchestra
    orc.source(source)
    orc.compose_with(composer)
    orc.new.process_until_exhausted
  end
end
