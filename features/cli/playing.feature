Feature: The command line interface `play` command
  For the user it should be easy to play an orchestra.

  Scenario: Builtin--Echo
    Given a file named "test.txt" with:
    """
    line 1
    line 2

    """
    When I run `zq play Echo` interactively
    And I pipe in the file "test.txt"
    Then the output should contain "line 1"
    Then the output should contain "line 2"
    And the exit status should be 0


