module Clockwork
  # @author James Inman <james@mediaburst.co.uk>
  # Wrapper around NET/HTTP
  class HTTP

    class << self
      attr_writer :adapter, :connection

      # Build a HTTP POST request.
      # @param [string] url URL to POST to
      # @param [string] data Body of the POST request.
      # @param [boolean] use_ssl Whether to use SSL when making the request.
      # @return [string] XML data
      def post url, data = '', use_ssl = true
        connection.post do |req|
          req.url uri_from url, use_ssl

          req.headers["Content-Type"] = "text/xml"
          req.headers["User-Agent"]   = "Clockwork Ruby Wrapper/#{Clockwork::VERSION}"

          req.body = data
        end
      end

      private

      def uri_from(url, use_ssl)
        protocol = use_ssl ? "https" : "http"

        URI.parse "#{protocol}://#{url}"
      end

      def connection
        @connection ||= Faraday.new do |faraday|
          faraday.adapter adapter
        end
      end

      def adapter
        @adapter ||= Faraday.default_adapter
      end
    end
  end

end
