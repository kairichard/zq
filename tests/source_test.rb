require 'test_helper'

class STDINTestCase < ZQTestCase
  def test_read_next
    file = StringIO.new
    file.puts 'line1'
    file.puts 'line2'
    file.rewind
    source = ZQ::Sources::IOSource.new file
    assert_source_read_sequence ['line1', 'line2', nil], source
  end
end

