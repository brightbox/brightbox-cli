### v2.8.0 / 2017-10-31

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.7.1...v2.8.0)

Enhancements:

* Adds IPv6 details to the Server and Cloud IP detailed views.

Changes:

* Update `fog-brightbox` to v0.14.0

### v2.7.1 / 2017-09-11

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.7.0...v2.7.1)

Bug fixes:

* Remove debugging line left over in `server create`

### v2.7.0 / 2017-09-06

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.6.0...v2.7.0)

Enhancements:

* Add `cloud-ip` argument to `server create` command to pre-allocate and map
  a cloud IP to a server upon build completion.

Changes:

* Update `fog-brightbox` to v0.13.0
* Various changes to Travis settings

### v2.6.0 / 2016-07-07

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.5.0...v2.6.0)

Enhancements:

* Add `maintenance-weekday` and `maintenance-hour` to `sql instance` commands.
  This allows setting of a custom maintenance window if the default of Sunday
  between 06:00-06:59 UTC does not suit for your application.
  The maintenance window is used to automatically apply security updates to the
  instance.
* Add args `snapshots-schedule` and `remove-snapshots-schedule` to `sql instance`
  command to enable setting up schedules for automatic snapshots of data. The
  argument to set takes a crontab format string (e.g. "0 5 * * 0") to specify
  when it should occur. Schedules must be at hourly or more.

Bug fixes:

* Fix handling of creation time to not error if excluded from JSON.
* Fix handling of SQL instance's cloud IP is excluded from JSON.

Changes:

* Update `fog-brightbox` to v0.11.0
* Corrected naming of a number of VCR recordings.

### v2.5.0 / 2016-06-20

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.4.1...v2.5.0)

Released in error with only version bump.

### v2.4.1 / 2016-06-06

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.4.0...v2.4.1)

Enhancements:

* Optimise API call used when listing images

### v2.4.0 / 2016-01-20

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.3.4...v2.4.0)

Changes:

* Update `fog-brightbox` to v0.10.1
* Default behaviour of fog-brightbox v0.10.0 is to use collapsed API response
  to account listing resulting in faster calls in `brightbox accounts list`
* Various changes to Travis settings

### v2.3.4 / 2015-11-23

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.3.3...v2.3.4)

Bug fixes:

* Lock `mime-types` to 2.x series. Ruby 1.9.3 support is dropped in v3.0 (fixes GH#80)

### v2.3.3 / 2015-11-04

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.3.2...v2.3.3)

Bug fixes:

* Fixed issue where `brightbox servers show` would not display a server's zone.

### v2.3.2 / 2015-10-26

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.3.1...v2.3.2)

Bug fixes:

* Fix issue when `login` command prompt twice for password (or prompt once even
  when already supplied) due to reusing cached but expired refresh token.

### v2.3.1 / 2015-10-26

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.3.0...v2.3.1)

Bug fixes:

* Fix issue when `login` command would reset custom URLs to the defaults.

### v2.3.0 / 2015-10-23

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.2.0...v2.3.0)

Enhancements:

* Adds embedded client that is used when a user has not setup their own
  application.
* Adds `brightbox login` command which allows a simplified login for users with
  just their email address and password (prompted).

    brightbox login user@example.com

  This uses the embedded application to save extra steps setting up.

Bug fixes:

* Guard against errors when using `DEBUG=true` whilst configuration is not
  selected triggering a `NoMethodError`
* Use `pry-remote` for debugging. `pry` runs in process and the IO is trapped
  when testing and in some error cases making it unusable.
* Fix configuration code so it can initialise without network side effects when
  reading client_name and other values.

### v2.2.0 / 2015-09-28

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.1.2...v2.2.0)

Enhancements:

* Add `BRIGHTBOX_API_URL` ENV for running against alternative endpoints.

Bug fixes:

* Specify some expected errors to avoid specs passing when new errors
  introduced.
* Fix image list sorting using "status" field.
* Handle error when `$config` is nil

Changes:

* Update to use `fog-brightbox v0.9.0`
* Remove 1.8.7 testing references.
* Declare `net-ssh` dependency as < 3.0 for Ruby 1.9.3 compatibility.

### v2.1.2 / 2015-07-18

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.1.1...v2.1.2)

Bug fixes:

* Return non 0 exit codes when CLI has an error

### v2.1.1 / 2015-07-17

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.1.0...v2.1.1)

Bug fixes:

* Update `fog-brightbox` dependency to 0.8.0 to ensure fqdn attribute is there.

### v2.1.0 / 2015-07-16

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.0.0...v2.1.0)

Enhancements:

* Cloud IP's fully qualified domain name (e.g. cip-12345.gb1.brightbox.com) is
  available within the output from the "show" command.

Bug fixes:

* Removed duplicate `reverse_dns` entry from CIP show output
* Removed extra `fog-core` dependency. Should be determined by `fog-brightbox`

### v2.0.0 / 2015-07-08

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.6.0...v2.0.0)

Backwards incompatible changes:

* Dropped support for Ruby 1.8.7

Changes:

* Removed `mime-types` dependency constraint (added just for 1.8.7 compatibility)

### v1.6.0 / 2015-04-24
[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v1.5.0...v1.6.0)

Enhancements:

* Updated list of autocompleted server handles to include all current versions
  including SSD versions.

Changes:

* Default server type has changed to `1gb.ssd`. This can be changed with the
  `--type (-t)` argument to specify alternatives as before.

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
