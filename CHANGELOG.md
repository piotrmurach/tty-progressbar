# Change log

## [v0.18.2] - 2021-03-08

### Fixed
* Fix calculating total in MultiBar with indeterminate children by Tim Tilberg(@ttilberg)

## [v0.18.1] - 2021-01-25

### Fixed
* Fix :eta and :eta_time format tokens display when progress isn't started

## [v0.18.0] - 2021-01-20

### Added
* Add #resume to allow stopped or paused bar to continue progressing
* Add :clear_head option to remove head when progress is done
* Add #configure to allow runtime configuration
* Add Multi#done? to check if all bar are stopped or finished
* Add indeterminate progress support when no total is given
* Add :bar_format option to allow selecting preconfigured bar displays
* Add :eta_time format token to display the estimated time of day at completion
* Add measurement of the total elapsed time that ignores stopped time intervals
* Add #pause to prevent bar from continuing progression and suspend time measurements
* Add Multi#pause to allow suspending progression of all registered bars at once
* Add Multi#resume to start again all registered bars that are stopped or paused
* Add Timer class to handle the total elapsed time measurements

### Changed
* Change Multi#stopped? to check that all bars are stopped
* Change gemspec to load version directly and remove test artifacts
* Change to update strings-ansi and tty-screen dependencies
* Change Pipeline to inject progress bar instance only once
* Change :elapsed and :eta to show days after running for 24 hours
* Change to ensure complete, incomplete and unknown option cannot be an empty string
* Change to allow setting total to nil via accessor
* Change gemspec to allow version 2.0 of unicode-display_width dependency
* Change #stop to show hidden cursor after render similar to #finish

### Fixed
* Fix MultiBar top bar to allow resuming progress when stopped/done (@d4be4st)
* Fix MultiBar to only set width when top bar present

## [v0.17.0] - 2019-05-31

### Changed
* Change gemspec to load files directly without git
* Change to update tty-cursor and tty-screen dependencies

## [v0.16.0] - 2018-08-27

### Added
* Add strings-ansi dependency

### Changed
* Change tty-cursor dependency version

### Fixed
* Fix to handle ANSI codes in bar formatting to allow correct size calculation

## [v0.15.1] - 2018-07-19

### Fixed
* Fix to always restore hidden cursor by Eric Hodel(@drbrain)

## [v0.15.0] - 2018-06-24

### Added
* Add #format= for overriding formatting string
* Add #display_columns for determining display width of multibyte characters
* Add :inset option to bar configuration options
* Add ability to configure width for multi bar with top level bar
* Add unicode-display_width dependency

### Changed
* Change #update to only set configuration if actually present
* Change bar formatter to handle multibyte characters

### Fixed
* Fix to stop reseting multibar state when registered bar reset by Eric Hodel(@drbrain)
* Fix rendered bar to pad formatted output when it gets shorter by Eric Hodel(@drbrain)
* Fix multi bar to advance in steps matching each bar advance progress
* Fix multi bar rendering for widths exceeding screen columns count

## [v0.14.0] - 2018-01-17

### Changed
* Change to only output to a console and stop output to a file, pipe etc...
* Change #iterate to accept enumerators as collection type by Victor Shepelev(@zverok)

### Fixed
* Fix #iterate to take into account progress value in total steps calculation

## [v0.13.0] - 2017-10-29

### Changed
* Change tty-screen dependency version
* Change gemspec to require Ruby >= 2.0.0
* Remove encoding comments

## [v0.12.2] - 2017-09-15

### Changed
* Change to automatically start & update top level progress bar
  when registered bars advance

## [v0.12.1] - 2017-09-09

### Added
* Add rspec to gem development dependencies

### Changed
* Change line clearing to rely on tty-cursor

### Fixed
* Fix multi bar finishing before registered progress bars

## [v0.12.0] - 2017-09-03

### Added
* Add :head option to allow changing bar head progression character
* Add thread safety to allow sharing progress between multiple threads
* Add #update to allow changing bar configuration options
* Add #stop to stop bar in current position and terminate any further progress
* Add #iterate to progress over a collection
* Add validation to check if bar formatting string is provided
* Add ability to listen for completion events such as :done, :progress and :stopped
* Add TTY::ProgressBar::Multi for creating parallel multiple progress bars

### Changed
* Change to stop mutating strings
* Change #reset to stop drawing and use for initialization

### Fixed
* Fix configuration to add interval option

## [v0.11.0] - 2017-04-04

### Added
* Add :decimals, :separator, :unit_separator to Converter#to_bytes
* Add ability to Converter#to_bytes to calculate higher sizes TB, PB & EB

### Changed
* Change files loading
* Change Converter to be a module

### Fixed
* Fix :byte_rate token to correctly format bytes

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

[v0.18.2]: https://github.com/piotrmurach/tty-progressbar/compare/v0.18.1...v0.18.2
[v0.18.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.18.0...v0.18.1
[v0.18.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.17.0...v0.18.0
[v0.17.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.16.0...v0.17.0
[v0.16.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.15.1...v0.16.0
[v0.15.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.15.0...v0.15.1
[v0.15.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.14.0...v0.15.0
[v0.14.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.13.0...v0.14.0
[v0.13.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.12.2...v0.13.0
[v0.12.2]: https://github.com/piotrmurach/tty-progressbar/compare/v0.12.1...v0.12.2
[v0.12.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.12.0...v0.12.1
[v0.12.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.11.0...v0.12.0
[v0.11.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.10.1...v0.11.0
[v0.10.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.10.0...v0.10.1
[v0.10.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.9.0...v0.10.0
[v0.9.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.8.2...v0.9.0
[v0.8.2]: https://github.com/piotrmurach/tty-progressbar/compare/v0.8.1...v0.8.2
[v0.8.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.8.0...v0.8.1
[v0.8.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.5.1...v0.6.0
[v0.5.1]: https://github.com/piotrmurach/tty-progressbar/compare/v0.5.0...v0.5.1
[v0.5.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/piotrmurach/tty-progressbar/compare/v0.1.0
