### v1.2.0 / 2014-03-10
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.1.0...v1.2.0)

Enhancements:

* Adds support for Cloud SQL instances to the CLI.
* Uses modular `fog-brightbox` gem to cut down on unnecessary dependencies
  included using full `fog` gem.
* Can view more details related to SSL certificates on load balancers.
* Rely on API output to check which resources can have Cloud IPs mapped.
* `json` gem is no longer a hard dependency. If faster versions are available
  they should be detected automatically.

Bug Fixes:

* `brightbox images show` and `brightbox lbs show` no longer error when
   identifiers are not passed but display all resources like other commands.
* Help instructions for option arguments are correct following GLI update.
