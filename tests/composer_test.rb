require 'test_helper'

class EchoComposerTestCase < ZQTestCase
  def test_compose
    composer = ZQ::Composer::Echo.new
    test_data = "a"
    assert_equal test_data, composer.compose(test_data)
  end
end

