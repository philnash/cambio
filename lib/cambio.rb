require "faraday"
require "faraday_middleware"
require "hashie"
require 'faraday/raise_on_error'
require "cambio/version"
require "cambio/configuration"
require "cambio/error"

# Wrapper for the Open Exchange Rates API
module Cambio
  class << self
    # Public: Configure the API wrapper. A convenience method that yields a
    # configuration object on which you can set the app_id and endpoint.
    #
    # Examples
    #
    #   Cambio.configure do |config|
    #     config.app_id = 'YOUR_APP_ID'
    #   end
    def configure
      yield(configuration)
    end

    # Public: Access to the underlying configuration object
    def configuration
      @configuration ||= Configuration.new
    end

    # Public: Retrieve the latest rates from the API
    #
    # opts - A hash of options to affect the returned result (default: {}):
    #        :raw - A Boolean to describe whether you want the raw JSON response
    #
    # Examples
    #
    #   Cambio.latest
    #   # => #<Hashie::Mash base="USD" ... >
    #
    #   Cambio.latest :raw => true
    #   # => "{\n\t\"disclaimer\": \"This data..." ... }"
    #
    # # Returns a Hashie::Mash of the rates (or raw JSON, if raw is passed)
    def latest(opts={})
      response = connection(opts).get 'latest.json'
      response.body
    end

    # Public: Retrieve the currencies supplied by the API
    #
    # opts - A hash of options to affect the returned result (default: {}):
    #        :raw - A Boolean to describe whether you want the raw JSON response
    #
    # Examples
    #
    #   Cambio.currencies
    #   # => #<Hashie::Mash AED="United Arab Emirates Dirham" ... >
    #
    #   Cambio.currencies
    #   # => "{\n\t\"AED\": \"United Arab Emirates Dirham\", ... }"
    #
    # Returns a Hashie::Mash of the currencies (or raw JSON, if raw is passed)
    def currencies(opts={})
      response = connection(opts).get 'currencies.json'
      response.body
    end

    # Public: Retrieve the historical rates supplied by the API
    #
    # date - A string in the format YYYY-MM-DD or a date object referring to the
    #        day on which you want to get the rates from
    # opts - A hash of options to affect the returned result (default: {}):
    #        :raw - A Boolean to describe whether you want the raw JSON response
    #
    # Examples
    #
    #   Cambio.historical('2012-08-17')
    #
    #   Cambio.historical(Date.today)
    #
    # Returns a Hashie::Mash of the rates from the date specified (or raw JSON,
    # if raw is passsed)
    def historical(date, opts={})
      date = date.strftime("%Y-%m-%d") if date.respond_to?(:strftime)
      response = connection(opts).get "historical/#{date}.json"
      response.body
    end

    private

    # Internal: access to a faraday connection
    def connection(opts={})
      Faraday.new(:url => configuration.endpoint, :params => { :app_id => configuration.app_id }) do |conn|
        unless opts[:raw]
          conn.response :mashify
          conn.response :json
        end
        conn.response :raise_on_error
        conn.adapter Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
  end
end
