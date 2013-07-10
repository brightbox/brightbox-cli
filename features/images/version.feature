Feature: Version
  In order to know they have the latest and greatest version of the CLI
  Users should be able to discover the version of the "brightbox-images" command

  Scenario: Get version
    When I run `brightbox-images -v`
    Then the output should contain the version information
