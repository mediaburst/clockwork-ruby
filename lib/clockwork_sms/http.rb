module ClockworkSMS
  
  # @author James Inman <james@mediaburst.co.uk>
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
      req.body = data
      req.add_field "User-Agent", "ClockworkSMS Ruby Wrapper/#{ClockworkSMS::VERSION}"
      
      response = socket.start do |http|
        http.request( req )
      end
      
      response
    end

  end
  
end