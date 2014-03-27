require 'test_helper'

class EchoComposerTestCase < ZQTestCase
  def test_compose_returns_data
    test_data = "a"
    composer = ZQ::Composer::Echo.new
    result = composer.compose(test_data)
    assert_equal(test_data, result)
  end
  def test_compose_stdout_implicit
    test_data = "a"
    assert_output test_data + "\n" do
      composer = ZQ::Composer::Echo.new
      composer.compose(test_data)
    end
  end
  def test_compose_stdout_explicit
    test_data = "a"
    assert_output test_data + "\n" do
      composer = ZQ::Composer::Echo.new $stdout
      composer.compose(test_data)
    end
  end
  def test_compose_favours_composite_data_overraw_data
    test_data_raw = "a"
    test_data_composite = "A"
    file = StringIO.new
    composer = ZQ::Composer::Echo.new file
    composer.compose(test_data_raw, test_data_composite)
    assert_equal(test_data_composite + "\n", file.string)
  end
  def test_compose_to_file
    test_data = "a"
    file = StringIO.new
    composer = ZQ::Composer::Echo.new file
    composer.compose(test_data)
    assert_equal(test_data + "\n", file.string)
  end
end

