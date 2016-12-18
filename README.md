# TTY::ProgressBar [![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]
[![Gem Version](https://badge.fury.io/rb/tty-progressbar.svg)][gem]
[![Build Status](https://secure.travis-ci.org/piotrmurach/tty-progressbar.svg?branch=master)][travis]
[![Build status](https://ci.appveyor.com/api/projects/status/w3jafjeatt1ulufa?svg=true)][appveyor]
[![Code Climate](https://codeclimate.com/github/piotrmurach/tty-progressbar/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-progressbar/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty-progressbar.svg?branch=master)][inchpages]

[gitter]: https://gitter.im/piotrmurach/tty
[gem]: http://badge.fury.io/rb/tty-progressbar
[travis]: http://travis-ci.org/piotrmurach/tty-progressbar
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-progressbar
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-progressbar
[coverage]: https://coveralls.io/github/piotrmurach/tty-progressbar
[inchpages]: http://inch-ci.org/github/piotrmurach/tty-progressbar

> A flexible progress bars drawing in terminal emulators.

**TTY::ProgressBar** provides independent progress bars component for [TTY](https://github.com/piotrmurach/tty) toolkit.

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
  * [1.4 width=](#14-width)
  * [1.5 start](#15-start)
  * [1.6 finish](#16-finish)
  * [1.7 complete?](#17-complete)
  * [1.8 reset](#18-reset)
  * [1.9 resize](#19-resize)
* [2. Configuration](#2-configuration)
  * [2.1 Frequency](#21-frequency)
  * [2.2 Interval](#22-interval)
* [3. Formatting](#3-formatting)
  * [3.1 Tokens](#31-tokens)
  * [3.2 Custom Formatters](#32-custom-formatters)
  * [3.3 Custom Tokens](#33-custom-tokens)
* [4. Logging](#4-logging)
* [5. Examples](#5-examples)
  * [5.1 Color](#51-color)

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

### 1.4 width=

You can set how many terminal columns will the `:bar` actually span excluding any other tokens and/or text. For example if you need the bar to be always 20 columns wwide do:

```ruby
bar.width = 20
```

or with configuration options:

```ruby
bar = TTY::ProgressBar.new("[:bar]", width: 20)
```

### 1.5 start

By default the timer for internal time esitamation is started automatically when the `advance` method is called. However, if you require control on when the progression timer is started use `start` call:

```ruby
bar.start  # => sets timer and draws initial progress bar
```

### 1.6 finish

In order to immediately stop and finish the progress call `finish`. This will finish drawing the progress and return to new line.

```ruby
bar.finish
```

### 1.7 complete?

During progresion you can check if bar is finished or not by calling `complete?`.

```ruby
bar.complete? # => false
```

### 1.8 reset

In order to reset currently running or finished progress bar to its original configuration and initial position use `reset` like so:

```ruby
bar.reset
```

### 1.9 resize

If you wish for a progress bar to change it's current width, you can use `resize` by passing in a new desired length. However, if you don't provide any width the `resize` will use terminal current width as its base for scaling.

```ruby
bar.resize      # => determine terminal width and scale accordingly
bar.resize(50)  # => will resize bar proportionately from this point onwards
```

To handle automatic resizing you can trap `:WINCH` signal:

```ruby
trap(:WINCH) { bar.resize }
```

## 2. Configuration

There are number of configuration options that can be provided:

* `total` total number of steps to completion
* `width` of the bars display in terminal columns excluding formatting options. Defaults to total steps
* `complete` completion character by default `=`
* `incomplete` incomplete character by default single space
* `output` the output stream defaulting to `stderr`
* `frequency` used to throttle the output, by default `0` (see [Frequency](#21-frequency))
* `interval` used to measure the speed, by default `1 sec` (see [Interval](#22-interval))
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

### 2.2 Interval

For every call of `advance` method the **ProgressBar** takes a sample for speed measurement. By default the samples are grouped per second but you can change that by passing the `interval` option.

The `interval` option is an `integer` that represents the number of seconds, for example, interval of `60` would mean that speed is measured per 1 minute.

```ruby
TTY::ProgressBar.new(":rate/minute", total: 100, interval: 60) # 1 minute

TTY::ProgressBar.new(":rate/hour", total: 100, interval: 3600) # 1 hour
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
* `:rate` the current rate of progression per second
* `:byte_rate` the current rate of pregression in bytes per second
* `:mean_rate` the averaged rate of progression per second
* `:mean_byte` the averaged rate of progression in bytes per second

### 3.2 Custom Formatters

If the provided tokens do not meet your needs, you can write your own formatter and instrument formatting pipeline to use a formatter you prefer. This option is preferred if you are going to rely on progress bar internal data such as `rate`, `current` etc. which will all be available on the passed in progress bar instance.

For example, begin by creating custom formatter called `TimeFormatter` that will dynamicly update `:time` token in format string. The methods that you need to specify are `initialize`, `matches?` and `format` like follows:

```ruby
class TimeFormatter
  def initialize(progress)
    @progress = progress # current progress bar instance
  end

  def matches?(value)  # specify condition to match for in display string
    value.to_s =~ /:time/
  end

  def format(value)  # specify how display string is formatted
    transformed = (Time.now - @progress.start_at).to_s
    value.gsub(/:time/, transformed)   # => :time token replacement
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

and then invoke progression:

```ruby
bar.advance
```

### 3.3 Custom Tokens

You can define custom tokens by passing pairs `name: value` to `advance` method in order to dynamically update formatted bar. This option is useful for lightweight content replacement such as titles that doesn't depend on the internal data of progressbar. For example:

```ruby
bar = TTY::ProgressBar.new("(:current) :title", total: 4)
bar.advance(title: 'Hello Piotr!')
bar.advance(3, title: 'Bye Piotr!')
```

which outputs:

```ruby
(1) Hello Piotr!
(4) Bye Piotr!
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

Creating a progress bar that displays in color is as simple as coloring the `:complete` and `:incomplete` character options. In order to help with coloring you can use [pastel](https://github.com/piotrmurach/pastel) library like so:

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

### 5.2 Speed

Commonly a progress bar is utilized to measure download speed per second. This can be done like so:

```ruby
TTY::ProgressBar.new("[:bar] :byte_rate/s") do |config|
  config.total = 300000
  config.interval = 1     # => 1 sec
end
```

This will result in output similar to:

```ruby
downloading [=======================       ] 4.12MB/s
```

## Contributing

1. Fork it ( https://github.com/piotrmurach/tty-progressbar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014-2016 Piotr Murach. See LICENSE for further details.
