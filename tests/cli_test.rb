require 'test_helper'

class CLITestCase < ZiwTestCase

  def test_cli_orchestrates_and_exhausts
    value = '{"key": "value"}'
    get_data_source.insert value
    cli = Zimtw::CLI.new([], [])
    cli.invoke(:work)
      assert_equal 1, get_repo.all.length
  end

  def test_cli_can_run_forever
    opts = [
      "-d", true
    ]
    stub.proxy(TestOrchestra).new do |obj|
      mock(obj).process_forever
    end
    cli = Zimtw::CLI.new([], opts)
    cli.invoke(:work)
  end

  def test_cli_orchestrates_with_only_one_orchestra
    value = '{"key": "value"}'
    get_data_source.insert value
    opts = [
      "-o", "NotHere"
    ]
    cli = Zimtw::CLI.new([], opts)
    cli.invoke(:work)
    assert get_repo.all.length == 0
  end
end

