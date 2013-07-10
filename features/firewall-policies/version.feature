Feature: Version
  In order to know they have the latest and greatest version of the CLI
  Users should be able to discover the version of the "brightbox-firewall-policies" command

  Scenario: Get version
    When I run `brightbox-firewall-policies -v`
    Then the output should contain the version information
