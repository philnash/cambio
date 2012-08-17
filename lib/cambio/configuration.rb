module Cambio
  # Internal: An object to hold the internal configuration of the Cambio module
  class Configuration
    # Public: Gets/Sets the String app_id
    attr_accessor :app_id
    # Public: Gets/Sets the String endpoint
    attr_accessor :endpoint

    # Internal: By default, don't set an app ID
    DEFAULT_APP_ID = nil

    # Internal: The default API endpoint, it can also be set to use https
    DEFAULT_ENDPOINT = 'http://openexchangerates.org/api/'

    # Internal: The configuration object should be initialized by the Cambio
    # module
    def initialize
      @endpoint = DEFAULT_ENDPOINT
    end

    # Public: resets the internal configuration to the defaults
    #
    # Examples
    #
    #   configuration.reset
    def reset
      @endpoint = DEFAULT_ENDPOINT
      @app_id   = DEFAULT_APP_ID
    end
  end
end