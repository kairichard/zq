require 'test_helper'

Test1 = ZQ.create_orchestra
Test2 = ZQ.create_orchestra

class CLITestCase < ZQTestCase
  include OrchestraTestCaseMixin

  def test_cli_can_run_forever
    Test1.source(Object.new)
    Test1.add_composer(Object.new)
    expect_any_instance_of(Test1).to receive(:process_forever)
    opts = ['Test1','-d', true]
    ZQ::CLI.new([], opts).invoke(:play)
  end

  def test_cli_play_orchestra_sleep_after_read
    Test2.source(create_source([:value, :value]))
    Test2.add_composer(ZQ::Composer::NoOp.new)
    expect(Kernel).to receive(:sleep).with(0.1)
    opts = ['Test2', '-i', 0.1]
    ZQ::CLI.new([], opts).invoke(:play)
  end

  def test_cli_play_orchestra_which_is_not_available
    opts = %w{NotHere}
    cli = ZQ::CLI.new([], opts)
    assert_raises OrchestraDoesNotExist do
      cli.invoke(:play)
    end
  end
end
