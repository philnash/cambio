# Cambio

A gem to wrap the Open Exchange Rates API from http://openexchangerates.org

## Installation

Add this line to your application's Gemfile:

    gem 'cambio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cambio

## Usage

First you will need an App ID, you can sign up for one at https://openexchangerates.org/signup.

    Cambio.configure do |config|
      config.app_id = 'YOUR APP ID'
    end

Get the latest exchange rates

    Cambio.latest

You can also get the raw JSON response

    Cambio.latest :raw => true

Get the currencies available through the API

    Cambio.currencies
    # or
    Cambio.currencies :raw => true

Get the historical exchange rates

    Cambio.historical('2012-08-17')
    # or with a date object
    Cambio.historical(Date.parse('17/08/2012'))

## Supported Ruby versions

This has been tested with ruby 1.9.2 and 1.9.3


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
