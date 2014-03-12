Feature: Listing available orchestras
  Scenario: Empty current dir
    Given I run `zq list`
    Then the output should contain "No Orchestras found"
    And the exit status should be 1
