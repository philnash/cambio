require 'json' unless defined?(::JSON)
module FaradayMiddleware
  class RaiseOnError < Faraday::Response::Middleware
    def on_complete(env)
      case env[:status]
      when 404
        raise Cambio::NotFoundError, build_message(env)
      when 401
        raise Cambio::UnauthorisedError, build_message(env)
      when 500
        raise Cambio::ServerError, build_message(env)
      when 400...600
        raise Cambio::Error, build_message(env)
      end
    end

    private

    def build_message(env)
      body = get_body(env[:body])
      "#{env[:status]}: #{body['message']}. #{body['description']}"
    end

    def get_body(body)
      if !body.nil? && !body.empty? && body.kind_of?(String)
        parsed_body = ::JSON.parse(body)
      end
      parsed_body.nil? || parsed_body.empty? ? {} : parsed_body
    end
  end
end
Faraday.register_middleware :response, :raise_on_error => FaradayMiddleware::RaiseOnError