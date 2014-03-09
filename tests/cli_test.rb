require 'test_helper'

class CLITestCase < ZiwTestCase

  def test_cli_orchestrates_and_exhausts
    value = '{"key": "value"}'
    get_data_source.insert value
    cli = Zimtw::CLI.new([], [])
    cli.invoke(:work)
    assert get_repo.all.length == 1
  end

  def test_cli_orchestrates_and_exhausts
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

