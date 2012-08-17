module Cambio
  # Internal: Custom error class for all other Cambio errors
  class Error < StandardError; end

  # Internal: Raised when trying to use the API with the wrong or no credentials
  class UnauthorisedError < Error; end

  # Internal: Raised when 404 error is returned from the API
  class NotFoundError < Error; end

  # Internal: Raised when a 500 error is returned from the API
  class ServerError < Error; end
end