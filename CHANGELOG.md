### v5.0.0 / 2025-01-20

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.8.0...v5.0.0)

Backwards incompatible changes:

* Drop support for Ruby versions older than 2.7
* Update `Gemfile.lock` to use Bundler 2.4.22
* When ENV `HOME` is not set, the working directory is used for configs
  rather than `/.brightbox` to fix issues with containers
* `show` commands require at least one argument to
   prevent an issue where the wrong, summary API was
   used resulting in missing data in tables
* `images` architecture is now its own `arch` column and no longer
  combined with the name field.

Enhancements:

* Added support for ACME certificates
* `brightbox lbs create` and `update` accepts `--acme-domains` with CSV
  domains to request them to be setup on the load balancer
* `brightbox lbs show` outputs ACME related fields
  * `acme_domains` - domains requested to be present
  * `acme_cert_expires` - when the ACME certificate in no longer valid
  * `acme_cert_fingerprint` - the fingerprint of the ACME certificate
  * `acme_cert_issued_at` - when the ACME certificate was issued
  * `acme_cert_subjects` - domain present on ACME certificate
* `brightbox firewall-policy` is now an alias for `firewall-policies`

Changes:

* `brightbox images` will now report an deprecated and private image as
  "private" rather than "deprecated"
* Update `fog-brightbox` to `v1.12.0`
* Numerous dependency gems updated
* Expanded debugging output
* `Brightbox::Api#attributes` attempts to transform and make attributes
  indifferent to String or Symbol keys as that has introduced numerous
  issues over the years. Fog only converts the top level of keys from
  Strings to Symbols resulting in mismatched keys throughout
* Refactored all models `#attributes` and `#to_row` methods to use the
  above with more involved testing

Bug fixes:

* `brightbox lbs create` no longer requires at least one node to balance
  which was outdated client side validation long removed from the API
* `brightbox lbs create` should now recognise the `--buffer-size` option
* `brightbox lbs update` converts `buffer-size` to integer before sending
* `brightbox cloudips unmap` incorrectly used the "map" description in
  the help output. This is now fixed

Testing:

* Update CI testing matrix from Ruby 2.7 up to 3.3
* Ensure bundler version declared in `Gemfile.lock` is used by CI tests
* CI setting completes all builds rather than cancelling on one fail
* CI testing includes `DEBUG` ENV settings
* Tests updated to not "fail" when `DEBUG` output is included upsetting
  matches to expected output in numerous cases
* Simplecov has been introduced and configured to prevent a drop in
  test coverage.
* Temporary testing config directories are removed explicitly to prevent
  config bleeding in some test scenarios
* Tests for `server activate_console` confirm support for local time and
  time zones.

### v4.8.0 / 2024-10-23

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.7.0...v4.8.0)

Changes:

* Increase supported Server `user-data` limit to match 64KiB now
  supported by API.

### v4.7.0 / 2024-01-03

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.6.0...v4.7.0)

Changes:

* Expose `image_username` to `servers show` output

### v4.6.0 / 2023-02-22

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.5.0...v4.6.0)

Changes:

* Remove `accounts ftp_reset_password` subcommand. The FTP service has been
  retired so the command would receive an error from the API.
* Remove `--source` option from `images register`. This was tied to the FTP
  based registration which is no longer supported. Using `url` on a HTTP
  source is now the preferred option for custom uploads.
* Update `mime-types-data` gem to `3.2023.0218.1`

### v4.5.0 / 2023-02-08

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.5.0.rc1...v4.5.0)

Bug fixes:

* Correct locale references to `sql instances reset` and `resize` help text.

Changes:

* Corrected previous CHANGELOG entry related to the update to `fog-brightbox` to show `v1.9.1` not `v1.7.0`

### v4.5.0.rc1 / 2023-01-26

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.4.0...v4.5.0.rc1)

Enhancements:

* Added `sql instances reset` subcommand for restarting DBMS on a database server.
* Added `sql instances resize` subcommand for increasing database server resources.

### v4.4.0 / 2023-01-26

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.3.2...v4.4.0)

Enhancements:

* Added `configmaps` subcommand for managing config map resources.

### v4.3.2 / 2023-01-12

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.3.1...v4.3.2)

Bug fixes:

* Declared top level help for `volumes` subcommand.
* Fix `volumes update --delete-with-server` switch.
* Fix `lbs update --sslv3` switch.
* Fix `servers update --compatibility-mode` switch.

Changes:

* Added a `ignore_default` option to GLI DSL, by monkey patching, to prevent
  unexpected switches from interfering with API calls. In some cases it was
  impossible to determine if `--feature` or `--no-feature` had been used in the
  command OR added as a default in GLI. This meant `update` commands would always
  send `feature: false` in API requests even when updating names and other fields.
  This could clear setting unexpectedly due to the behaviour.
* Test `servers create --compatibility-mode` switch.
* Test `cloudips update --delete-reverse-dns` switch.
* Test `sql instances --remove-snapshots-schedule` switch.

### v4.3.1 / 2023-01-11

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.3.0...v4.3.1)

Bug fixes:

* Fix `help` output crashing when encountering Array in locale file.

### v4.3.0 / 2023-01-11

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.2.1...v4.3.0)

Enhancements:

* Adds `volumes` subcommand for Volume management.

Changes:

* Update `fog-brightbox` to `v1.9.1`

### v4.2.1 / 2022-11-16

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.2.0...v4.2.1)

Bug fixes:

* Bumped version of `highline` gem to fix issue when prompting for password during `brightbox login` command on Ruby 3.0+.
* Fixed help output for `brightbox login` by correcting DSL declaration.

### v4.2.0 / 2022-11-01

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.1.0...v4.2.0)

Enhancements:

* Adds three new, mutually exclusive options to `images create` to specify
  different sources:
  * `url` can specify source as a URL for a HTTP or HTTPS download rather than
     an existing FTP upload.
  * `server` can specify a server ID to create a snapshot image from.
  * `volume` can specify a volume ID to create a snapshot image from.

### v4.1.0 / 2022-08-01

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v4.0.0...v4.1.0)

Enhancements:

* Adds `volume-size` to `servers create` to allow passing of arbitrary sizes for
  network based storage types.

### v4.0.0 / 2022-08-01

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v3.3.0...v4.0.0)

Backwards incompatible changes:

* Drop support for Ruby versions older than 2.5
* Update `Gemfile.lock` to use Bundler 2.1.4
* Remove hypenated versions of sub commands. For example `brightbox-servers`
  wrapping `brightbox servers`.

Changes:

* Improved Two Factor Authentication (2FA) support resulting in it working
  automatically without configuration prompting when required. The `two_factor`
  configuration setting is now ignored
* The `brightbox login` command will now work when 2FA is enabled for a user
* Adds Ruby 3.1 and 3.2 (preview) to testing matrix
* Update `fog-brightbox` to `v1.7.0`
* Removed references to `Fixnum` from code and dependencies to allow
  testing of Ruby 3.2 support
* Updates `webmock` from 1.21.0 to 3.14.0
* Removes `rubyforge` reference from gemspec to remove deprecation warning
* Remove post install message from gemspec
* Update `gli` to latest version v2.21.0 to clear some deprecations seen under
  later Ruby versions
* Update development gems to ensure up to date
* Change `client_id` logging level from info to debug
* Setup Rubocop to help improve code quality/consistency
* Updated code based on Rubocop reports resulting in many changes
* Pin `dry-inflector` to v0.2.0 to prevent issues with Ruby =< 2.5
* Add support for `min-ram` to `brightbox images` commands
* Update authors (and emails) in gemspec

Bug fixes:

* Implement `Brightbox::Api#respond_to_missing?` to avoid issues when
  delegating made `#respond_to?` raise an error
* `brightbox login` no longer attempts (and fails) to download accounts when
  authentication has failed

Testing:

* Updated testing/development gems
* Update VCR to latest release v2.9.3
* Remove VCR identifier sanitisation as temp dev instance are used and
  squashing IDs cause bug when chain/multiple requests combined
* RSpec is configured to allow re-runs
* Timeout testing is dropped to 10s
* Updated `.dev` TLD used in testing to `.localhost` to avoid problems when the
  original was commercialised such as local DNS blocked by browsers.

### v3.3.0 / 2021-09-17

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v3.2.0...v3.3.0)

Changes:

* Update `fog-brightbox` to v1.4.0` (allowing Ruby 3.0 support)
* Added support for getting 2FA from helper
* Added missing `sql snapshot` fields
* Infrastructure changes to test on more versions of Ruby
* Added GitHub actions support for CI testing.
* Removed Travis CI support.

Bug fixes:

* Updates `crack` gem to switch from `safe_yaml` to `rexml`
* Bump addressable from 2.3.8 to 2.8.0. (fixing ReDoS vulnerability)
* Bump rexml from 3.2.4 to 3.2.5 (fixing round-trip vulnerability bugs)

### v3.2.0 / 2020-11-26

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v3.1.0...v3.2.0)

Changes:

* Add `--disk-encrypted` option to server creation to allow enabling encryption
  at rest during a build.
* Setup GitHub Actions for Ruby 2.4+ builds to reduce the delays of testing
  using Travis.
* Reduce number of Travis builds due to incredibly slow start up times. We are
  approaching an hour to get a build taking less than a minute starting.

### v3.1.0 / 2020-11-17

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v3.0.1...v3.1.0)

Changes:

* Update `fog-brightbox` to v1.2.0
* Add `lbs` option for `--min-ssl-ver` to specify the minimum TLS/SSL protocol
  that should be acceptable for use with the load balancer

### v3.0.1 / 2020-07-01

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v3.0.0...v3.0.1)

Bug fixes:

* Fix `cloudips update --name` to correctly set blank names

### v3.0.0 / 2020-07-01

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.12.0...v3.0.0)

Backwards incompatible changes:

* Dropped support for Ruby 1.9

Changes:

* Update `fog-brightbox` to v1.1.0
* Update `rake` to v12.3.3 to resolve CVE-2020-8130
* Update `rspec` to v3.9 to avoid issue when updating `rake`

Bug fixes:

* Creating an SQL instance from an existing snapshot has been fixed following
  the update for `fog-brightbox v1.1.0`

### v2.12.0 / 2020-01-28

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.11.2...v2.12.0)

Enhancements:

* Adds `token create` to always attempt to reauthenticate and display a token.

### v2.11.2 / 2020-01-07

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.11.1...v2.11.2)

Bug fixes:

* Update `excon` to v0.71.0 to fix security issue.

### v2.11.1 / 2019-10-29

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.11.0...v2.11.1)

Bug fixes:

* Constrain version of `dry-inflector` to ensure gem can work with older
  versions of Ruby.

### v2.11.0 / 2019-06-06

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.10.0...v2.11.0)

Enhancements:

* Prompts for 2FA token if set up on a user account being used to authenticate.

### v2.10.0 / 2019-03-20

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.9.3...v2.10.0)

Enhancements:

* Support for using an external password manager by setting in configuration

### v2.9.3 /2019-03-06

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.9.2...v2.9.3)

Bug fixes:

* Fixes `servers activate_console` URL generated from new API output to remove
  invalid trailing slash.

### v2.9.2 /2018-09-07

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.9.1...v2.9.2)

Bug fixes:

* Pins `fog-brightbox` to v0.16.1 to include a fix to avoid deprecation warnings
  although only present when using fog-core > 2.0
* Pins `fog-core` dependency to < 2.0 to restore Ruby 1.9 support and avoid
  upstream breaking changes.
* Fixes an errant space in the `brightbox token` curl format output.

### v2.9.1 /2018-09-06

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.9.0...v2.9.1)

Bug fixes:

* Pins `fog-core` dependency to < 2.1.1 where some deprecation checks have
  broken everything.

### v2.9.0 /2018-08-24

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.8.2...v2.9.0)

Enhancements:

* Adds `brightbox token` command to read currently cached OAuth2 bearer tokens

### v2.8.2 /2018-08-21

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.8.1...v2.8.2)

Bug fixes:

* Fix image list filter when using `--account/-l` options caused by hash key
  type change somewhere in the stack.

Changes:

* Update `fog-brightbox` to v0.15.0
* Limit `fog-brightbox` dependency to < 1.0 to avoid issue following major update
* Add Jenkinsfile for internal CI

### v2.8.1 / 2018-04-10

[Full Changelog](https://github.com/brightbox/brightbox-cli/compare/v2.8.0...v2.8.1)

Changes:

* Remove unused net-ssh dependency (gregkare)

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
