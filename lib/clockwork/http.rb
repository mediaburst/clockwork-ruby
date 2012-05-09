module Clockwork
  
  # Wrapper around NET/HTTP
  class HTTP
    
    # Build a HTTP POST request.
    # @param [string] url URL to POST to
    # @param [string] data Body of the POST request.
    # @param [boolean] use_ssl Whether to use SSL when making the request.
    # @return [string] XML data
    def self.post url, data = '', use_ssl = true
      if use_ssl
        uri = URI.parse "https://#{url}"
        req = Net::HTTP::Post.new( uri.path )
    
        socket = Net::HTTP.new( uri.host, uri.port )
        socket.use_ssl = true
        socket.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        uri = URI.parse "http://#{url}"
        req = Net::HTTP::Post.new( uri.path )
    
        socket = Net::HTTP.new( uri.host, uri.port ) 
      end
      
      req.content_type = "text/xml" 
      # req.initialize_http_header( 'User-Agent' => "Clockwork .NET Wrapper/#{Clockwork::VERSION}" )
      req.body = data
      
      response = socket.start do |http|
        http.request( req )
      end
      
      response      
    end

  end
  
end