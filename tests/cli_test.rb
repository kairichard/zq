require 'test_helper'

class CLITestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_cli_can_run_forever
    orc = create_orchestra
    orc.source(Object.new)
    orc.add_composer(Object.new)
    orc.name('test')
    opts = ['test','-d', true]
    stub.proxy(orc).new do |obj|
      mock(obj).process_forever
    end
    cli = ZQ::CLI.new([], opts)
    cli.invoke(:play)
  end

  def test_cli_play_orchestra_which_is_not_available
    opts = %w{NotHere}
    cli = ZQ::CLI.new([], opts)
    assert_raises OrchestraDoesNotExist do
      cli.invoke(:play)
    end
  end
end
