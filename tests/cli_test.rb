require 'test_helper'

class CLITestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_cli_can_run_forever
    orc = ZQ.create_orchestra
    orc.source(Object.new)
    orc.add_composer(Object.new)
    orc.name('test')
    expect_any_instance_of(orc).to receive(:process_forever)
    opts = ['test','-d', true]
    cli = ZQ::CLI.new([], opts)
    cli.invoke(:play)
  end

  def test_cli_play_orchestra_sleep_after_read
    opts = ['test', '-i', 0.1]
    source = double("source")
    expect(source).to receive(:read_next).exactly(3).times.and_return(:value1, :value2, nil)
    expect(Kernel).to receive(:sleep).with(0.1)
    orc = ZQ.create_orchestra
    orc.source(source)
    orc.add_composer(EchoComposer.new)
    orc.name('test')
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
