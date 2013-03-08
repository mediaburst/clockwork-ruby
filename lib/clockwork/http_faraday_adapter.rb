module Clockwork
  class HttpFaradayAdapter
    class << self
      def connection
        Faraday.new(:url => 'http://sushi.com') do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end

      def post url, data = '', use_ssl = true
        uri = if use_ssl
                URI.parse "https://#{url}"
              else
                URI.parse "http://#{url}"
              end

        connection.post do |req|
          req.url uri
          req.headers['Content-Type'] = 'text/xml'
          req.headers["User-Agent"]   =  "Clockwork Ruby Wrapper/#{Clockwork::VERSION}"
          req.body = data
        end
      end
    end
  end
end
