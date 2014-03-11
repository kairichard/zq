require 'test_helper'

class CLITestCase < ZiwTestCase
  include OrchestraTestCaseMixin

  def test_cli_can_run_forever
    orc = create_orchestra "FooBarCli2"
    opts = [
      "-d", true
    ]
    stub.proxy(orc).new do |obj|
      mock(obj).process_forever
    end
    cli = ZQ::CLI.new([], opts)
    cli.invoke(:work)
  end

  def test_cli_orchestrates_with_only_one_orchestra_which_is_not_available
    opts = [
      "-o", "NotHere"
    ]
    cli = ZQ::CLI.new([], opts)
    assert_raises Exception do
      cli.invoke(:work)
    end
    assert_equal 0, get_repo.all.length
  end
end

