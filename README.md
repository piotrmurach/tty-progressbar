<div align="center">
  <a href="https://ttytoolkit.org"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="TTY Toolkit logo"/></a>
</div>

# TTY::ProgressBar [![Gitter](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[![Gem Version](https://badge.fury.io/rb/tty-progressbar.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-progressbar/workflows/CI/badge.svg?branch=master)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/w3jafjeatt1ulufa?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/e85416137d2057169575/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-progressbar/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/piotrmurach/tty-progressbar.svg?branch=master)][inchpages]

[gitter]: https://gitter.im/piotrmurach/tty
[gem]: http://badge.fury.io/rb/tty-progressbar
[gh_actions_ci]: https://github.com/piotrmurach/tty-progressbar/actions?query=workflow%3ACI
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-progressbar
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-progressbar/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-progressbar
[inchpages]: http://inch-ci.org/github/piotrmurach/tty-progressbar

> A flexible and extensible progress bar for terminal applications.

**TTY::ProgressBar** provides independent progress bar component for [TTY](https://github.com/piotrmurach/tty) toolkit.

## Features

* **Customisable.** Choose from many [configuration](#3-configuration) options to get the behaviour you want.
* **Flexible.** Describe bar [format](#4-formatting) and pick from many predefined [tokens](#41-tokens) and [bar styles](#37-bar_format).
* **Extensible.** Define [custom tokens](#42-custom-formatters) to fit your needs.
* **Powerful.** Display [multi](#6-ttyprogressbarmulti-api) progress bars in parallel.
* Show an unbounded operation with [indeterminate](#31-total) progress.
* [Pause](#210-pause) and [resume](#212-resume) progress at any time.
* Include [Unicode](#44-unicode) characters in progress bar.
* Works on all ECMA-48 compatible terminals.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty-progressbar"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install tty-progressbar
```

## Contents

* [1. Usage](#1-usage)
* [2. TTY::ProgressBar::API](#2-ttyprogressbar-api)
  * [2.1 advance](#21-advance)
  * [2.2 iterate](#22-iterate)
  * [2.3 current=](#23-current)
  * [2.4 ratio=](#24-ratio)
  * [2.5 width=](#25-width)
  * [2.6 start](#26-start)
  * [2.7 update](#27-update)
  * [2.8 finish](#28-finish)
  * [2.9 stop](#29-stop)
  * [2.10 pause](#210-pause)
  * [2.11 reset](#211-reset)
  * [2.12 resume](#212-resume)
  * [2.13 complete?](#213-complete)
  * [2.14 paused?](#214-paused)
  * [2.15 stopped?](#215-stopped)
  * [2.16 indeterminate?](#216-indeterminate)
  * [2.17 resize](#217-resize)
  * [2.18 on](#218-on)
* [3. Configuration](#3-configuration)
  * [3.1 :total](#31-total)
  * [3.1 :width](#32-width)
  * [3.3 :complete](#33-complete)
  * [3.4 :incomplete](#34-incomplete)
  * [3.5 :head](#35-head)
  * [3.6 :unknown](#36-unknown)
  * [3.7 :bar_format](#37-bar_format)
  * [3.8 :output](#38-output)
  * [3.9 :frequency](#39-frequency)
  * [3.10 :interval](#310-interval)
  * [3.11 :hide_cursor](#311-hide_cursor)
  * [3.12 :clear](#312-clear)
  * [3.13 :clear_head](#313-clear_head)
* [4. Formatting](#4-formatting)
  * [4.1 Tokens](#41-tokens)
  * [4.2 Custom Formatters](#42-custom-formatters)
  * [4.3 Custom Tokens](#43-custom-tokens)
  * [4.4 Unicode](#44-unicode)
* [5. Logging](#5-logging)
* [6. TTY::ProgressBar::Multi API](#6-ttyprogressbarmulti-api)
  * [6.1 new](#61-new)
  * [6.2 register](#62-register)
  * [6.3 advance](#63-advance)
  * [6.4 start](#64-start)
  * [6.5 finish](#65-finish)
  * [6.6 stop](#66-stop)
  * [6.7 pause](#67-pause)
  * [6.8 resume](#68-resume)
  * [6.9 complete?](#69-complete)
  * [6.10 paused?](#610-paused)
  * [6.11 stopped?](#611-stopped)
  * [6.12 on](#612-on)
  * [6.13 :style](#613-style)
* [7. Examples](#7-examples)
  * [7.1 Color](#71-color)
  * [7.2 Speed](#72-speed)

## 1. Usage

**TTY::ProgressBar** requires only a format string with `:bar` [token](#41-tokens) and total number of steps to completion:

```ruby
bar = TTY::ProgressBar.new("downloading [:bar]", total: 30)
```

Once initialized, use [advance](#21-advance) method to indicated progress:

```ruby
30.times do
  sleep(0.1)
  bar.advance  # by default increases by 1
end
```

This would produce the following animation in your terminal:

```ruby
# downloading [=======================       ]
```

You can further change a progress bar behaviour and display by changing [configuration](#3-configuration) options and using many predefined [tokens](#41-tokens) and [bar formats](#37-bar_format).

When you don't know the total yet, you can set it to `nil` to switch to [indeterminate](#31-total) progress:

```ruby
# downloading [       <=>                    ]
```

Use [TTY::ProgressBar::Multi](#6-ttyprogressbarmulti-api) to display multiple parallel progress bars.

Declare a top level bar and then register child bars:

```ruby
bars = TTY::ProgressBar::Multi.new("main [:bar] :percent")

bar1 = bars.register("one [:bar] :percent", total: 15)
bar2 = bars.register("two [:bar] :percent", total: 15)
```

Then progress the child bars in parallel:

```ruby
bars.start  # starts all registered bars timers

th1 = Thread.new { 15.times { sleep(0.1); bar1.advance } }
th2 = Thread.new { 15.times { sleep(0.1); bar2.advance } }

[th1, th2].each { |t| t.join }
```

A possible terminal output may look like this:

```ruby
# ┌ main [===============               ] 50%
# ├── one [=====          ] 34%
# └── two [==========     ] 67%
```

## 2. TTY::ProgressBar API

### 2.1 advance

Once you have **TTY::ProgressBar** instance, you can progress the display by calling `advance` method. By default, it will increase by `1` but you can pass any number of steps, for instance, a number of bytes for a downloaded file:

```ruby
bar.advance(1024)
```

You can also pass negative steps if you wish to backtrack the progress:

```ruby
bar.advance(-1)
```

*Note:* If a progress bar has already finished then any negative steps will not set it back to desired value.

### 2.2 iterate

To simplify progressing over an enumerable you can use `iterate` which as a first argument accepts an `Enumerable` and as a second the amount to progress the bar with.

First, create a progress bar without a total which will be automatically updated for you once iteration starts:

```ruby
bar = TTY::ProgressBar.new("[:bar]")
```

Then, either directly iterate over a collection by yielding values to a block:

```ruby
bar.iterate(30.times) { |v| ... }
```

Or return an `Enumerator`:

```ruby
progress = bar.iterate(30.times)
# => #<Enumerator: #<Enumerator::Generator:0x...:each>
```

By default, progress bar is advanced by `1` but you can change it by passing second argument:

```ruby
bar.iterate(30.times, 5)
```

One particularly useful application of `iterate` are Ruby infamous [lazy enumerators](http://ruby-doc.org/core-2.5.0/Enumerator/Lazy.html), or slowly advancing enumerations, representing complex processes.

For example, an `Enumerator` that downloads content from a remote server chunk at a time:

```ruby
downloader = Enumerator.new do |y|
  start = 0
  loop do
    yield(download_from_server(start, CHUNK_SIZE))
    raise StopIteration if download_finished?
    start += CHUNK_SIZE
  end
end
```

Would be used with progress bar with the total size matching the content size like so:

```ruby
bar = TTY::ProgressBar.new("[:bar]", total: content_size)
# you need to provide the total for the iterate to avoid calling enumerator.count
response = bar.iterate(downloader, CHUNK_SIZE).to_a.join
```

This would result in progress bar advancing after each chunk up until all content has been downloaded, returning the result of the download in `response` variable.

Please run [slow_process example](examples/slow_process.rb) to see this in action.

### 2.3 current=

A progress doesn't have to start from zero. You can set it to a given value using `current=` method:

```ruby
bar.current = 50
```

*Note:* If a progress bar has already finished then setting current value will not have any effect.

### 2.4 ratio=

In order to update overall completion of a progress bar as an exact percentage use the `ratio=` method. The method accepts values between `0` and `1` inclusive. For example, a ratio of `0.5` will attempt to set the progress bar halfway:

```ruby
bar.ratio = 0.5
```

### 2.5 width=

You can set how many terminal columns will the `:bar` actually span excluding any other tokens and/or text.

For example, if you need the bar to be always 20 columns wide do:

```ruby
bar.width = 20
```

Or with configuration options:

```ruby
bar = TTY::ProgressBar.new("[:bar]", width: 20)
```

### 2.6 start

By default the timer for internal time estimation is started automatically when the `advance` method is called. However, if you require control on when the progression timer is started use `start` call:

```ruby
bar.start  # => sets timer and draws initial progress bar
```

### 2.7 update

Once a progress bar has been started, you can change its configuration option(s) by calling `update`:

```ruby
bar.update(complete: "+", frequency: 10)
```

### 2.8 finish

In order to immediately stop and finish progress of a bar call `finish`. This will finish drawing the progress by advancing it to 100% and returning to a new line.

```ruby
bar.finish
```

### 2.9 stop

In order to immediately stop a bar in the current position and thus prevent any further progress use `stop`:

```ruby
bar.stop
```

### 2.10 pause

A running progress bar can be paused at the current position using `pause` method:

```ruby
bar.pause
```

A paused progress bar will stop accumulating any time measurements like elapsed time. It also won't return to a new line, so a progress animation can be smoothly resumed.

### 2.11 reset

In order to reset currently running or finished progress bar to its original configuration and initial position use `reset` like so:

```ruby
bar.reset
```

After resetting a progress bar, if you wish to draw and start a bar and its timers use `start` call.

### 2.12 resume

When a bar is stopped or paused, you can continue its progression using the `resume` method.

```ruby
bar.resume
```

A resumed progression will continue accumulating the total elapsed time without including time intervals for pausing or stopping.

### 2.13 complete?

During progression you can check whether a bar is finished or not by calling `complete?`. The bar will only return `true` if the progression finished successfully, otherwise `false` will be returned.

```ruby
bar.complete? # => false
```

### 2.14 paused?

To check whether a progress bar is paused or not use `paused?`:

```ruby
bar.paused? # => true
```

### 2.15 stopped?

To check whether a progress bar is stopped or not use `stopped?`:

```ruby
bar.stopped? # => true
```

### 2.16 indeterminate?

You can make a progress bar indeterminate by setting `:total` to `nil`. In this state, a progress bar animation is displayed to show unbounded task. You can check whether the progress bar is indeterminate with the `indeterminate?` method:

```ruby
bar.indeterminate? # => false
```

### 2.17 resize

If you want to change a progress bar's current width, use `resize` and pass in a new desired length. However, if you don't provide any width the `resize` will use terminal current width as its base for scaling.

```ruby
bar.resize      # determine terminal width and scale accordingly
bar.resize(50)  # will resize bar proportionately from this point onwards
```

To handle automatic resizing you can trap `:WINCH` signal:

```ruby
trap(:WINCH) { bar.resize }
```

### 2.18 on

A progress bar fires events when it is progressing, paused, stopped or finished. You can register to listen for these events using the `on` message.

Every time an `advance` is called the `:progress` event gets fired which you can listen for inside a block. A first yielded argument is the actual amount of progress:

```ruby
bar.on(:progress) { |amount| ... }
```

When a progress bar finishes and completes then the `:done` event is fired. You can listen for this event:

```ruby
bar.on(:done) { ... }
```

Alternatively, when a progress bar gets stopped the `:stopped` event is fired. You can listen for this event:

```ruby
bar.on(:stopped) { ... }
```

Anytime a progress bar is paused the `:paused` event will be fired. To listen for this event do:

```ruby
bar.on(:paused) { ... }
```

## 3. Configuration

There are number of configuration options that can be provided:

* [:total](#31-total) - the total number of steps to completion.
* [:width](#32-width) - the number of terminal columns for displaying a bar excluding other tokens. Defaults to total steps.
* [:complete](#33-complete) - the completion character, by default `=`.
* [:incomplete](#34-incomplete) - the incomplete character, by default single space.
* [:head](#35-head) - the head character, by default `=`.
* [:unknown](#36-unknown) - the character(s) used to show indeterminate progress, defaults to `<=>`.
* [:bar_format](#37-bar_format) - the predefined bar format, by default `:classic`.
* [:output](#38-output) - the output stream defaulting to `stderr`.
* [:frequency](#39-frequency) - used to throttle the output, by default `0`.
* [:interval](#310-interval) - the time interval used to measure rate, by default `1 sec`.
* [:hide_cursor](#311-hide_cursor) - whether to hide the console cursor or not, defaults to `false`.
* [:clear](#312-clear) - whether to clear the finished bar or not, defaults to `false`.
* [:clear_head](#313-clear_head) - whether to clear the head character when the progress is done or not, defaults to `false`.

All the above options can be passed in as hash options or block parameters:

```ruby
bar = TTY::ProgressBar.new("[:bar]") do |config|
  config.total = 30
  config.frequency = 10
  config.clear = true
end
```

The progress bar's configuration can also be changed at runtime with `configure`:

```ruby
bar.configure do |config|
  config.total = 100   # takes precedence over the original value
  config.frequency = 20
end
```

Or with the [update](#27-update) method:

```ruby
bar.update(total: 100, frequency: 20)
```

### 3.1 :total

The `:total` option determines the final value at which the progress bar fills up and stops.

```ruby
TTY::ProgressBar.new("[:bar]", total: 30)
```

Setting `:total` to `nil` or leaving it out will cause the progress bar to switch to indeterminate mode. Instead of showing completeness for a task, it will render animation like `<=>` that moves left and right:

```ruby
# [                    <=>                 ]
```

The indeterminate mode is useful to show time-consuming and unbounded task.

Run [examples/indeterminate](https://github.com/piotrmurach/tty-progressbar/blob/master/examples/indeterminate.rb) to see indeterminate progress animation in action.

### 3.2 :width

The progress bar width defaults to the total value and is capped at the maximum terminal width minus all the labels. If you want to enforce the bar to have a specific length use the `:width` option:

```ruby
TTY::ProgressBar.new("[:bar]", width: 30)
```

### 3.3 :complete

By default, the `=` character is used to mark progression but this can be changed with `:complete` option:

```ruby
TTY::ProgressBar.new("[:bar]", complete: "x")
```

Then the output could look like this:

```ruby
# [xxxxxxxx      ]
```

### 3.4 :incomplete

By default no characters are shown to mark the remaining progress in the `:classic` bar format. Other [bar styles](#37-bar_format) often have incomplete character. You can change this with `:incomplete` option:

```ruby
TTY::ProgressBar.new("[:bar]", incomplete: "_")
```

A possible output may look like this:

```ruby
# [======_________]
```

### 3.5 :head

If you prefer for the animated bar to display a specific character for a head of progression then use `:head` option:

```ruby
TTY::ProgressBar.new("[:bar]", head: ">")
```

This could result in output like this:

```ruby
# [=======>      ]
```

### 3.6 :unknown

By default, a progress bar shows indeterminate progress using `<=>` characters:

```ruby
# [     <=>      ]
```

Other [bar formats](#37-bar_format) use different characters.

You can change this with the `:unknown` option:

```ruby
TTY::ProgressBar.new("[:bar]", unknown: "<?>")
```

This may result in the following output:

```ruby
# [     <?>      ]
````

### 3.7 :bar_format

There are number of preconfigured bar formats you can choose from.

| Name       | Determinate  | Indeterminate |
|:-----------|:-------------|:--------------|
| `:arrow`   | `▸▸▸▸▸▹▹▹▹▹` | `◂▸`          |
| `:asterisk`| `✱✱✱✱✱✳✳✳✳✳` | `✳✱✳`         |
| `:blade`   | `▰▰▰▰▰▱▱▱▱▱` | `▱▰▱`         |
| `:block`   | `█████░░░░░` | `█`           |
| `:box`     | `■■■■■□□□□□` | `□■□`         |
| `:bracket` | `❭❭❭❭❭❭❭❭❭❭` | `❬=❭`         |
| `:burger`  | `≡≡≡≡≡≡≡≡≡≡` | `<≡>`         |
| `:button`  | `⦿⦿⦿⦿⦿⦾⦾⦾⦾⦾` | `⦾⦿⦾`         |
| `:chevron` | `››››››››››` | `‹=›`         |
| `:circle`  | `●●●●●○○○○○` | `○●○`         |
| `:classic` | `==========` | `<=>`         |
| `:crate`   | `▣▣▣▣▣⬚⬚⬚⬚⬚` | `⬚▣⬚`         |
| `:diamond` | `♦♦♦♦♦♢♢♢♢♢` | `♢♦♢`         |
| `:dot`     | `･･････････` | `･･･`         |
| `:heart`   | `♥♥♥♥♥♡♡♡♡♡` | `♡♥♡`         |
| `:rectangle` | `▮▮▮▮▮▯▯▯▯▯` | `▯▮▯`       |
| `:square`  | `▪▪▪▪▪▫▫▫▫▫` | `▫▪▫`         |
| `:star`    | `★★★★★☆☆☆☆☆` | `☆★☆`         |
| `:track`   | `▬▬▬▬▬═════` | `═▬═`         |
| `:tread`   | `❱❱❱❱❱❱❱❱❱❱` | `❰=❱`         |
| `:triangle`| `▶▶▶▶▶▷▷▷▷▷` | `◀▶`          |
| `:wave`    | `~~~~~_____` | `<~>`         |

For example, you can specify `:box` format with the `:bar_format` option:

```ruby
TTY::ProgressBar.new("[:bar]", bar_format: :box)
```

This will result in output like this:

```ruby
# [■■■■■□□□□□□□□□□]
```

You can overwrite `:complete`, `:incomplete`, `:head` and `:unknown` characters:

```ruby
TTY::ProgressBar.new("[:bar]", bar_format: :box, incomplete: " ", unknown: "?")
```

This will display the following when total is given:

```ruby
# [■■■■■          ]
```

And for the unknown progress the `?` character will move from left to right:

```ruby
# [   ?           ]
```

### 3.8 :output

A progress bar only outputs to a console. When the output is, for example, redirected to a file or a pipe, the progress bar doesn't get printed. This is so, for example, your error logs do not overflow with progress bar output.

You can change where console output is streamed with `:output` option:

```ruby
bar = TTY::ProgressBar.new(output: $stdout)
```

The output stream defaults to `stderr`.

### 3.9 :frequency

Each time the `advance` is called it causes the progress bar to repaint. In cases when there is a huge number of updates per second, you may need to limit the rendering process by using the `frequency` option.

The `frequency` option accepts `integer` representing number of `Hz` units, for instance, frequency of 2 will mean that the progress will be updated maximum 2 times per second.

```ruby
TTY::ProgressBar.new("[:bar]", total: 30, frequency: 10) # 10 Hz
```

### 3.10 :interval

Every time `advance` method is called, a time sample is taken for speed measurement. By default, all the samples are grouped in second intervals to provide a rate of speed. You can change this by passing the `interval` option.

The `interval` option is an `integer` that represents the number of seconds, for example, interval of `60` would mean that speed is measured per 1 minute.

```ruby
TTY::ProgressBar.new(":rate/minute", total: 100, interval: 60) # 1 minute

TTY::ProgressBar.new(":rate/hour", total: 100, interval: 3600) # 1 hour
```

### 3.11 :hide_cursor

By default the cursor is visible during progress bar rendering. If you wish to hide it, you can do so with the `:hide_cursor` option.

Please note that hiding cursor changes user's terminal and you need to ensure that the cursor is made visible after your code finishes. This means also handling premature interrupt signals and other unpredictable events.

One solution is to wrap your progress rendering inside the `begin` and `ensure` like so:

```ruby
progress = TTY::ProgressBar.new("[:bar]", hide_cursor: true)

begin
  # logic to advance progress bar
ensure
  progress.stop # or progress.finish
  # both methods will ensure that cursor is made visible again
end
```

### 3.12 :clear

By default, when a progress bar finishes it returns to a new line leaving the last progress output behind.

If you prefer to erase a progress bar when it is finished use `:clear` option:

```ruby
TTY::ProgressBar.new("[:bar]", clear: true)
```

### 3.13 :clear_head

When a progress bar finishes and its animation includes [:head](#35-head) character, the character will remain in the output:

```ruby
# [=============>]
```

To replace a head character when a progress bar is finished use `:clear_head` option:

```ruby
TTY::ProgressBar.new("[:bar]", clear_head: true)
```

This will result in the following output:

```ruby
# [==============]
```

## 4. Formatting

Every **TTY::ProgressBar** instance requires a format string, which apart from regular characters accepts special tokens to display dynamic information. For instance, a format to measure download progress could be:

```ruby
"downloading [:bar] :elapsed :percent"
```

### 4.1 Tokens

These are the tokens that are currently supported:

* `:bar` the progress bar
* `:current` the current progress number
* `:current_byte` the current progress in bytes
* `:total` the total progress number
* `:total_byte` the total progress in bytes
* `:percent` the completion percentage
* `:elapsed` the elapsed time in seconds
* `:eta` the estimated time to completion in seconds
* `:eta_time` the estimated time of day at completion
* `:rate` the current rate of progression per second
* `:byte_rate` the current rate of progression in bytes per second
* `:mean_rate` the averaged rate of progression per second
* `:mean_byte` the averaged rate of progression in bytes per second

In the indeterminate mode, the progress bar displays `-` for tokens that cannot be calculated like `:total`, `:total_byte`, `:percent` and `:eta`. The following format:

```ruby
"[:bar] :current/:total :total_byte :percent ET::elapsed ETA::eta :rate/s"
```

Will result in:

```ruby
# [                 <=>                    ] 23/- -B -% ET: 1s ETA:--s 18.01/s
```

### 4.2 Custom Formatters

If the provided tokens do not meet your needs, you can write your own formatter and instrument formatting pipeline to use a formatter you prefer. This option is preferred if you are going to rely on progress bar internal data such as `rate`, `current` etc. which will all be available on the passed in progress bar instance.

For example, let's say you want to add `:time` token. First, start by creating a custom formatter class called `TimeFormatter` that will dynamically update `:time` token in the formatted string. In order for the `TimeFormatter` to recognise the `:time` token, you'll need to include the `TTY::ProgressBar::Formatter` module with a regular expression matching the token like so:

```ruby
class TimeFormatter
  include TTY::ProgressBar::Formatter[/:time/i]
  ...
end
```

Next, add `call` method that will substitute the matched token with an actual value. For example, to see the time elapsed since the start do:

```ruby
class TimeFormatter
  include TTY::ProgressBar::Formatter[/:time/i]

  def call(value)  # specify how display string is formatted
    # access current progress bar instance to read start time
    elapsed = (Time.now - progress.start_time).to_s
    value.gsub(matcher, elapsed)   # replace :time token with a value
  end
end
```

Notice that you have access to all the configuration options inside the formatter by simply invoking them on the `progress` instance.

Create **TTY::ProgressBar** instance using the new token:

```ruby
bar = TTY::ProgressBar.new(":time", total: 30)
```

Then add `TimeFormatter` to the pipeline like so:

```ruby
bar.use TimeFormatter
```

Then invoke progression:

```ruby
bar.advance
```

### 4.3 Custom Tokens

You can define custom tokens by passing pairs `name: value` to `advance` method in order to dynamically update formatted bar. This option is useful for lightweight content replacement such as titles that doesn't depend on the internal data of a progress bar. For example:

```ruby
bar = TTY::ProgressBar.new("(:current) :title", total: 4)
bar.advance(title: "Hello Piotr!")
bar.advance(3, title: "Bye Piotr!")
```

This will output:

```ruby
# (1) Hello Piotr!
# (4) Bye Piotr!
```

### 4.4 Unicode

The format string as well as [:complete](#33-complete), [:head](#35-head), [:incomplete](#34-incomplete) and [:unknown](#36-unknown) configuration options can contain Unicode characters that aren't monospaced.

For example, you can specify complete bar progression character to be Unicode non-monospaced:

```ruby
bar = TTY::ProgressBar.new("Unicode [:bar]", total: 30, complete: "あ")
```

Advancing above progress bar to completion will fit `あ` characters in 30 terminal columns:

```ruby
# Unicode [あああああああああああああああ]
```

Similarly, the formatted string can include Unicode characters:

```ruby
bar = TTY::ProgressBar.new("あめかんむり[:bar]", total: 20)
```

A finished progress bar will also fit within allowed width:

```ruby
# あめかんむり[==    ]
```

## 5. Logging

If you want to print messages out to terminal along with the progress bar use the `log` method. The messages will appear above the progress bar and will continue scrolling up as more are logged out.

```ruby
bar.log("Piotrrrrr")
bar.advance
```

This could result in the following output:

```ruby
# Piotrrrrr
# downloading [=======================       ]
```

## 6. TTY::ProgressBar::Multi API

### 6.1 new

The multi progress bar can be created in two ways. If you simply want to group multiple progress bars together, you can create multi bar without a format string like so:

```ruby
TTY::ProgressBar::Multi.new
```

However, if you want a top level multibar that tracks progress of all the registered progress bars then you need to provide a formatted string:

```ruby
TTY::ProgressBar::Multi.new("main [:bar] :percent")
```

### 6.2 register

To create a `TTY::ProgressBar` under the multibar use `register` like so:

```ruby
multibar = TTY::ProgressBar::Multi.new
bar = multibar.register("[:bar]", total: 30)
```

The `register` call returns the newly created progress bar that can be changed using all the available [progress bar API](#2-ttyprogressbar-api) methods.

*Note:* Remember to specify total value for each registered progress bar, either when sending `register` message or when using `update` to dynamically assign the total value.

### 6.3 advance

Once multi progress bar has been created you can advance each registered progress bar individually, either by executing them one after the other synchronously or by placing them in separate threads thus progressing each bar asynchronously. The multi bar handles synchronization and display of all bars as they continue their respective rendering.

For example, to display two bars asynchronously, first register them with the multi bar:

```ruby
bar1 = multibar.register("one [:bar]", total: 20)
bar2 = multibar.register("two [:bar]", total: 30)
```

Next place the progress behaviour in separate process or thread:

```ruby
th1 = Thread.new { 20.times { expensive_work(); bar1.advance } }
th2 = Thread.new { 30.times { expensive_work(); bar2.advance } }
```

Finally, wait for the threads to finish:

```ruby
[th1, th2].each { |t| t.join }
```

### 6.4 start

By default the top level multi bar will be rendered as the first bar and have its timer started when one of the registered bars advances. However, if you wish to start timers and draw the top level multi bar do:

```ruby
multibar.start  # => sets timer and draws top level multi progress bar
```

### 6.5 finish

In order to finish all progress bars call `finish`. This will finish the top level progress bar, if it exists, and any registered progress bar still in progress.

```ruby
multibar.finish
```

### 6.6 stop

Use `stop` to terminate immediately all progress bars registered with the multibar.

```ruby
multibar.stop
```

### 6.7 pause

All running progress bars can be paused at their current positions using the `pause` method:

```ruby
multibar.pause
````

### 6.8 resume

When one or more registered progress bar is stopped or paused, they can be resumed all at once using the `resume` method:

```ruby
multibar.resume
```

### 6.9 complete?

To check if all registered progress bars have been successfully finished use `complete?`

```ruby
multibar.complete? # => true
```

### 6.10 paused?

To check whether all progress bars are paused or not use `paused?`:

```ruby
multibar.paused? # => true
```

### 6.11 stopped?

To check whether all progress bars are stopped or not use `stopped?`:

```ruby
multibar.stopped? # => true
```

### 6.12 on

Similar to `TTY::ProgressBar` the multi bar fires events when it is progressing, stopped or finished. You can register to listen for events using the `on` message.

Every time any of the registered progress bars progresses the `:progress` event is fired which you can listen for:

```ruby
multibar.on(:progress) { ... }
```

When all the registered progress bars finish and complete then the `:done` event is fired. You can listen for this event:

```ruby
multibar.on(:done) { ... }
```

When any of the progress bars gets stopped the `:stopped` event is fired. You can listen for this event:

```ruby
multibar.on(:stopped) { ... }
```

Anytime a registered progress bar pauses, a `:paused` event will be fired. To listen for this event do:

```ruby
multibar.on(:paused) { ... }
```

### 6.13 :style

In addition to all [configuration options](#3-configuration) you can style multi progress bar:

```ruby
TTY::ProgressBar::Multi.new("[:bar]", style: {
  top: ". ",
  middle: "|-> ",
  bottom: "|__ "
})
```

## 7. Examples

This section demonstrates some of the possible uses for the **TTY::ProgressBar**, for more please see examples folder in the source directory.

### 7.1 Colors

Creating a progress bar that displays in color is as simple as coloring the `:complete` and `:incomplete` character options. In order to help with coloring you can use [pastel](https://github.com/piotrmurach/pastel) library like so:

```ruby
require "pastel"

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

### 7.2 Speed

Commonly a progress bar is utilized to measure download speed per second. This can be done like so:

```ruby
TTY::ProgressBar.new("[:bar] :byte_rate/s") do |config|
  config.total = 300000
  config.interval = 1     # => 1 sec
end
```

This will result in output similar to:

```ruby
# downloading [=======================       ] 4.12MB/s
```

## Contributing

1. Fork it ( https://github.com/piotrmurach/tty-progressbar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the TTY::ProgressBar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotrmurach/tty-progressbar/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2014 Piotr Murach. See LICENSE for further details.
