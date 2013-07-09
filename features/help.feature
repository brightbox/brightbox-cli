Feature: Top level help
  In order to know what I can do with the CLI
  Users should be able to discover supported commands

  Scenario: Get help
    When I run `brightbox help`
    Then the exit status should be 0
     And the output should contain "accounts"
