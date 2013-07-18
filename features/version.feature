Feature: Version
  In order to know they have the latest and greatest version of the CLI
  Users should be able to discover the version of the "brightbox" command

  Scenario: Get version
    When I run `brightbox --version`
    Then the exit status should be 0
     And the output should contain the version information
