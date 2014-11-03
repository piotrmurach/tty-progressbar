# TTY::ProgressBar
[![Gem Version](https://badge.fury.io/rb/tty-progressbar.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty-progressbar.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty-progressbar.png)][codeclimate]

[gem]: http://badge.fury.io/rb/tty-progressbar
[travis]: http://travis-ci.org/peter-murach/tty-progressbar
[codeclimate]: https://codeclimate.com/github/peter-murach/tty-progressbar

A flexible progress bars drawing in terminal emulators.

## Features

* Extremly flexible progress display formatting
* Ability to define your custom format tokens
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
  * [1.1 finish](#12-finish)
* [2. Configuration](#2-configuration)
  * [2.1 Frequency](#21-frequency)
* [3. Formatting](#3-formatting)
  * [3.1 Tokens](#31-tokens)
  * [3.2 Custom Formatters](#31-custom-formatters)
* [4. Logging](#4-logging)

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

Once you have **ProgressBar** instance, you can progress the display by calling `advance` method. By default it will increase by `1`  but you can pass any number of steps, for instance, when used to advance number of bytes of downloaded file.

```ruby
bar.advance(1000)
```

### 1.2 finish

In order to immediately stop and finish the progress call `finish`. This will finish drawing the progress and return to new line.

```ruby
bar.finish
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
* `:total` the total progress number
* `:percent` the completion percentage
* `:elapsed` the elapsed time in seconds
* `:eta` the esitmated time to completion in seconds

### 3.2 Custom Formatters

If the provided tokens do not meet your needs, you can write your own formatter and instrument formatting pipeline to use a formatter you prefer.

For example, begin by creating custom formatter called `TimeFormatter` that will dynamicly update `:time` token in format string as follows:

```ruby
class TimeFormatter
  def initialize(progress)
    @progress = progress
  end

  def format(value)
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

## Contributing

1. Fork it ( https://github.com/peter-murach/tty-progressbar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014 Piotr Murach. See LICENSE for further details.
