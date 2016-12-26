# Change log

## [v0.10.1] - 2016-12-26

### Fixed
* Fix redefinition of Configuration#total=

## [v0.10.0] - 2016-06-25

### Fixed
* Fix Meter#sample to accurately calculate rate and mean_rate by Sylvain Joyeux

## [v0.9.0] - 2016-04-09

### Fixed
* Fix #resize to stop raising error when finished

### Changed
* Remove #register_signals and leave the choice on how exit and resize are handled to developer

## [v0.8.1] - 2016-02-27

### Added
* Add progress bar #inspect

### Fixed
* Fix the progressbar resizing call, help from @squarism

## [v0.8.0] - 2016-02-07

### Changed
* Update tty-screen dependency

## [v0.7.0] - 2015-09-20

* Update tty-screen dependency

## [v0.6.0] - 2015-06-27

### Added
* Add ability to add custom tokens

### Changed
* Internal cleanup of parameters for formatters and pipeline
* Fix ratio to avoid division by zero by @sleewoo issue #9

## [v0.5.1] - 2015-05-31

* Update tty-screen dependency with bug fixes

## [v0.5.0] - 2015-01-01

### Added
* Add ability to reset progress
* Add start method for manually setting the timer
* Add meter to measure speed rate
* Add to_seconds converter
* Add :rate, :mean_rate, :byte_rate & :mean_byte formatters

### Changed
* Fix bug with finish not rendering the bar full

## [v0.4.0] - 2014-12-25

### Added
* Add :total_byte, :current_byte formatters by @vincentjames501
* Add current= method for updating progress to a given value by @vincentjames501
* Add ratio= method for updating progress ratio

## [v0.3.0] - 2014-12-21

### Added
* Add tty-screen dependency for terminal size detection
* Add to_bytes converter
* Add formatter for managing formats pipeline
* Add block configuration

### Changed
* Catch INT signal and cleanly end progress
* Change to add matching condition to formatter

## [v0.2.0] - 2014-11-09

### Added
* Add estimated time formatter.
* Add frequency option to limit repainting of progress.
* Add log method for printing out during progress rendering.
* Add complete? for checking progress bar state

### Changed
* Fix bug with hide_cursor option
* Increase test coverage

## [v0.1.0] - 2014-11-01

* Initial implementation and release

[v0.10.1]: https://github.com/peter-murach/tty-progressbar/compare/v0.10.0...v0.10.1
[v0.10.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.9.0...v0.10.0
[v0.9.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.8.2...v0.9.0
[v0.8.2]: https://github.com/peter-murach/tty-progressbar/compare/v0.8.1...v0.8.2
[v0.8.1]: https://github.com/peter-murach/tty-progressbar/compare/v0.8.0...v0.8.1
[v0.8.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.5.1...v0.6.0
[v0.5.1]: https://github.com/peter-murach/tty-progressbar/compare/v0.5.0...v0.5.1
[v0.5.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/peter-murach/tty-progressbar/compare/v0.1.0
