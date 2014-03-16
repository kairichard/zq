Feature: The command line interface `play` command
  For the user it should be easy to play an orchestra.

  Scenario: STDIN-Echo
    Given a file named "test.rb" with:
    """
    require 'zq/orchestra'
    require 'zq/sources/io'
    require 'zq/composers/echo'

    class TestOrchestra
      include ZQ::Orchestra
      source ZQ::Sources::IOSource.new $stdin
      compose_with ZQ::Composer::Echo.new
    end
    """
    And a file named "test.txt" with:
    """
    line 1
    line 2

    """
    When I run `zq play TestOrchestra -r test.rb` interactively
    And I pipe in the file "test.txt"
    Then the output should contain "line 1"
    Then the output should contain "line 2"
    And the exit status should be 0


