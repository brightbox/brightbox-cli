Feature: Top level help
  In order to know what I can do with the CLI
  Users should be able to discover supported commands

  Scenario: Get help
    When I run `brightbox --help`
    Then the exit status should be 0
     And the output should contain "accounts"
     And the output should contain "cloudips"
     And the output should contain "config"
     And the output should contain "firewall-policies"
     And the output should contain "firewall-rules"
     And the output should contain "groups"
     And the output should contain "images"
     And the output should contain "lbs"
     And the output should contain "servers"
     And the output should contain "types"
     And the output should contain "users"
     And the output should contain "zones"
