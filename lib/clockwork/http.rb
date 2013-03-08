module Clockwork
  # @author James Inman <james@mediaburst.co.uk>
  # Wrapper around NET/HTTP
  class HTTP

    class << self
      attr_writer :adapter

      # Build a HTTP POST request.
      # @param [string] url URL to POST to
      # @param [string] data Body of the POST request.
      # @param [boolean] use_ssl Whether to use SSL when making the request.
      # @return [string] XML data
      def post url, data = '', use_ssl = true
        url = use_ssl ? "https://#{url}" : "http://#{url}"
        uri = URI.parse url

        connection.post do |req|
          req.url uri
          req.headers['Content-Type'] = 'text/xml'
          req.headers["User-Agent"]   =  "Clockwork Ruby Wrapper/#{Clockwork::VERSION}"
          req.body = data
        end
      end

      private

      def connection
        Faraday.new do |faraday|
          faraday.adapter adapter
        end
      end

      def adapter
        @adapter ||= Faraday.default_adapter
      end
    end
  end

end
