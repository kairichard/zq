require 'test_helper'

class EchoComposerTestCase < ZQTestCase
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
  def test_compose_to_file
    test_data = "a"
    file = StringIO.new
    composer = ZQ::Composer::Echo.new file
    composer.compose(test_data)
    assert_equal(test_data + "\n", file.string)
  end
end

