# TTY::ProgressBar
[![Gem Version](https://badge.fury.io/rb/tty-progressbar.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty-progressbar.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty-progressbar.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty-progressbar/badge.png)][coverage]

[gem]: http://badge.fury.io/rb/tty-progressbar
[travis]: http://travis-ci.org/peter-murach/tty-progressbar
[codeclimate]: https://codeclimate.com/github/peter-murach/tty-progressbar
[coverage]: https://coveralls.io/r/peter-murach/tty-progressbar

> A flexible progress bars drawing in terminal emulators.

**TTY::ProgressBar** provides independent progress bars component for [TTY](https://github.com/peter-murach/tty) toolkit.

## Features

* Fully [configurable](#2-configuration)
* Extremly flexible progress display [formatting](#3-formatting)
* Ability to define your custom format [tokens](#31-tokens)
* Works on all ECMA-48 compatible terminals

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tty-progressbar'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty-progressbar

## Contents

* [1. Usage](#1-usage)
  * [1.1 advance](#11-advance)
  * [1.2 current=](#12-current)
  * [1.3 ratio=](#13-ratio)
  * [1.4 finish](#14-finish)
  * [1.5 complete?](#15-complete)
  * [1.6 resize](#16-resize)
* [2. Configuration](#2-configuration)
  * [2.1 Frequency](#21-frequency)
* [3. Formatting](#3-formatting)
  * [3.1 Tokens](#31-tokens)
  * [3.2 Custom Formatters](#31-custom-formatters)
* [4. Logging](#4-logging)
* [5. Examples](#5-examples)

## 1. Usage

**TTY::ProgressBar** requires only format string and total number of steps to completion. Once initialized, use `advance` method to indicated the progress like so:

```ruby
bar = TTY::ProgressBar.new("downloading [:bar]", total: 30)
30.times do
  sleep(0.1)
  bar.advance(1)
end
```

This would produce animation in your terminal:

```ruby
downloading [=======================       ]
```

### 1.1 advance

Once you have **TTY::ProgressBar** instance, you can progress the display by calling `advance` method. By default it will increase by `1` but you can pass any number of steps, for instance, when used to advance number of bytes of downloaded file.

```ruby
bar.advance(1000)
```

You can also pass negative steps if you wish to backtrack the progress:

```ruby
bar.advance(-1)
```

Note: If a progress bar has already finished then negative steps will not set it back to desired value.

### 1.2 current=

**TTY::ProgressBar** allows you to set progress to a given value by calling `current=` method.

```ruby
bar.current = 50
```

Note: If a progress bar has already finished then negative steps will not set it back to desired value.

### 1.3 ratio=

In order to update overall completion of a progress bar as an exact percentage use the `ratio=` method. The method accepts values between `0` and `1` inclusive. For example, a ratio of 0.5 will attempt to set the progress bar halfway:

```ruby
bar.ratio = 0.5
```

### 1.4 finish

In order to immediately stop and finish the progress call `finish`. This will finish drawing the progress and return to new line.

```ruby
bar.finish
```

### 1.5 complete?

During progresion you can check if bar is finished or not by calling `complete?`.

```ruby
bar.complete? # => false
```

### 1.6 resize

If you wish for a progress bar to change it's current width, you can use `resize` by passing in a new desired length:

```ruby
bar.resize(50)  # => will resize bar proportionately from this point onwards
```

## 2. Configuration

There are number of configuration options that can be provided:

* `total` total number of steps to completion
* `width` for the bars display including formatting options defaulting to total
* `complete` completion character by default `=`
* `incomplete` incomplete character by default single space
* `output` the output stream defaulting to `stderr`
* `frequency` used to throttle the output, by default `0` (see [Frequency](#21-frequency))
* `hide_cursor` to hide display cursor defaulting to `false`
* `clear` to clear the finished bar defaulting to `false`

All the above options can be passed in as hash options or block parameters:

```ruby
TTY::ProgressBar.new "[:bar]" do |config|
  config.total = 30
  config.frequency = 10
  config.clear = true
end
```

### 2.1 Frequency

Each time the `advance` is called it causes the progress bar to repaint. In cases when there is a huge number of updates per second, you may need to limit the rendering process by using the `frequency` option.

The `frequency` option accepts `integer` representing number of `Hz` units, for instance, frequency of 2 will mean that the progress will be updated maximum 2 times per second.

```ruby
TTY::ProgressBar.new("[:bar]", total: 30, frequency: 10) # 10 Hz
```

## 3. Formatting

Every **TTY::ProgressBar** instance requires a format string, which apart from regular characters accepts special tokens to display dynamic information. For instance, a format to measure download progress could be:

```ruby
"downloading [:bar] :elapsed :percent"
```

### 3.1 Tokens

These are the tokens that are currently supported:

* `:bar` the progress bar
* `:current` the current progress number
* `:current_byte` the current progress in bytes
* `:total` the total progress number
* `:total_byte` the total progress in bytes
* `:percent` the completion percentage
* `:elapsed` the elapsed time in seconds
* `:eta` the esitmated time to completion in seconds

### 3.2 Custom Formatters

If the provided tokens do not meet your needs, you can write your own formatter and instrument formatting pipeline to use a formatter you prefer.

For example, begin by creating custom formatter called `TimeFormatter` that will dynamicly update `:time` token in format string. The methods that you need to specify are `initialize`, `matches?` and `format` like follows:

```ruby
class TimeFormatter
  def initialize(progress)
    @progress = progress
  end

  def matches?(value)  # specify condition to match for
    value.to_s =~ /:time/
  end

  def format(value)  # specify how value is formatted
    transformed = transform(value)
    value.gsub(/:time/, transformed.to_s)   # => :time token
  end

  private

  def transfrom
    value * (Time.now - @progress.start_at).to_i
  end
end
```

Notice that you have access to all the configuration options inside the formatter by simply invoking them on the `@progress` instance.

Create **TTY::ProgressBar** instance with new token:

```ruby
bar = TTY::ProgressBar.new(":time", total: 30)
```

Then add `TimeFormatter` to the pipeline like so:

```ruby
bar.use TimeFormatter
```

## 4. Logging

If you want to print messages out to terminal along with the progress bar use the `log` method. The messages will appear above the progress bar and will continue scrolling up as more are logged out.

```ruby
bar.log('Piotrrrrr')
bar.advance
```

will result in:

```ruby
Piotrrrrr
downloading [=======================       ]
```

## 5. Examples

This section demonstrates some of the possible uses for the **TTY::ProgressBar**, for more please see examples folder in the source directory.

### 5.1 Colors

Creating a progress bar that displays in color is as simple as coloring the `:complete` and `:incomplete` character options. In order to help with coloring you can use [pastel](https://github.com/peter-murach/pastel) library like so:

```ruby
require 'pastel'

pastel = Pastel.new
green  = pastel.on_green(" ")
red    = pastel.on_red(" ")
```

And then pass in the colored strings as options to **TTY::ProgressBar**:

```ruby
bar = TTY::ProgressBar.new("|:bar|",
  total: 30,
  complete: green,
  incomplete: red
)
```

To see how a progress bar is reported in terminal you can do:

```ruby
30.times do
  sleep(0.1)
  bar.advance
end
```

## Contributing

1. Fork it ( https://github.com/peter-murach/tty-progressbar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 Piotr Murach. See LICENSE for further details.
