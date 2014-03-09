require 'test_helper'

class CLITestCase < ZiwTestCase
  def test_cli_orchestrates
    value = '{"key": "value"}'
    get_data_source.insert value
    cli = Zimtw::CLI.new([], [])
    cli.invoke(:work)
    assert get_repo.all.is_a?(Array)
    assert get_repo.all.length == 1
  end
end

