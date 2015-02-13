### v1.5.0 / 2015-02-13
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.4.3...v1.5.0)

Enhancements:

* Add support for GPG stored user passwords.

### v1.4.3 / 2015-02-12
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.4.2...v1.4.3)

Bug fixes:

* Display error messages when DEBUG mode is enabled rather than suppressing.

### v1.4.2 / 2014-12-09
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.4.1...v1.4.2)

Bug fixes:

* Replace removed `Fog::VERSION` reference with `Fog::Core::VERSION` which was
  broken in a minor update of `fog-core`
* Dependency of `fog-core` now v1.25 minimum.

### v1.4.1 / 2014-12-08
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.4.0...v1.4.1)

Bug fixes:

* Lock `fog-core` to be `1.23.0` since `1.24+` broke things for modules and no
  apparently fix yet.

### v1.4.0 / 2014-10-22
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.3.0...v1.4.0)

Enhancements:

* Add `--buffer-size` argument to `lba create` to set the load balancers buffer
  size used.
* Add switch to enable/disable SSLv3 on the load balancer. Disabled by default
  on new load balancers it can be enabled with `--sslv3` when updating.

### v1.3.0 / 2014-08-20
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.2.2...v1.3.0)

Enhancements:

* Add `server reboot` command to send soft (OS level) restarts to server.
* Add `server reset` command to send hard (Hypervisor level) restart to server.
* Add `lock` and `unlock` commands to resources to prevent accidental deletion:
  * Servers
  * Images
  * Load balancers
  * SQL instances
  * SQL snapshots
* Can see lock status in a resource's details.

Bug fixes:

* Fix config `#persistent?` method if option was being sent.

Changes:

* Update `fog-brightbox` to v0.3.0
* Update `rspec` to `v2.99.1`
* Update specs
* Code style improvements

### v1.2.2 / 2014-04-22
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.2.1...v1.2.2)

Bug Fixes:

* Corrected Base64 encoding when updating a server's `user-data`. Behaviour
  had been inverted.

### v1.2.1 / 2014-03-11
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.2.0...v1.2.1)

Bug Fixes:

* Fixed the require to allow Ruby 1.8.7 to pick up Fog::JSON again
  [GH-57] https://github.com/brightbox/brightbox-cli/issues/57

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
