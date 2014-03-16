Feature: Listing available orchestras
  Scenario: With out a require file list system orchestras
    Given I run `zq list`
    Then the output should contain "Echo - prints contents from stdin"
    And the exit status should be 0

  Scenario: Orchestras in current dir
    Given a file named "test.rb" with:
    """
    require 'zq/orchestra'
    class TestOrchestra
      include ZQ::Orchestra
      desc "does nothing"
    end
    """
    When I run `zq list -r test.rb`
    Then the output should contain "TestOrchestra - does nothing"
    And the exit status should be 0

