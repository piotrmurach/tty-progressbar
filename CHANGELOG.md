0.5.0 (January 1, 2015)

* Add ability to reset progress
* Add start method for manually setting the timer
* Fix bug with finish not rendering the bar full
* Add meter to measure speed rate
* Add to_seconds converter
* Add :rate, :mean_rate, :byte_rate & :mean_byte formatters

0.4.0 (December 25, 2014)

* Add :total_byte, :current_byte formatters by @vincentjames501
* Add current= method for updating progress to a given value by @vincentjames501
* Add ratio= method for updating progress ratio

0.3.0 (December 21, 2014)

* Catch INT signal and cleanly end progress
* Add tty-screen dependency for terminal size detection
* Add to_bytes converter
* Add formatter for managing formats pipeline
* Change to add matching condition to formatter
* Add block configuration

0.2.0 (November 9, 2014)

* Add estimated time formatter.
* Add frequency option to limit repainting of progress.
* Add log method for printing out during progress rendering.
* Add complete? for checking progress bar state
* Fix bug with hide_cursor option
* Increase test coverage
