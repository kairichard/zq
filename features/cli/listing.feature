Feature: Listing available orchestras
  Scenario: Empty current dir
    Given I run `zq work`
    Then the output should contain "No Orchestras found"
