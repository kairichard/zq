require 'test_helper'

class STDINTestCase < ZQTestCase
  def test_read_next
    file = StringIO.new
    file.puts 'line1'
    file.puts 'line2'
    file.rewind
    source = ZQ::Sources::IOSource.new file
    assert_equal 'line1', source.read_next
    assert_equal 'line2', source.read_next
    assert_equal nil, source.read_next
  end
end

