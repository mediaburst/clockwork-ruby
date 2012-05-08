module Clockwork
  module XML
    
    # XML building and parsing for checking credit.
    class Credit
      
      # Build the XML data to check the credit from the XML API.
      # @param [Clockwork::API] api Instance of Clockwork::API
      # @return [string] XML data
      def self.build api
        if api.api_key
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.Credit {
              xml.Key api.api_key
            }
          end          
        else
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.Credit {
              xml.Username api.username
              xml.Password api.password
            }
          end
        end
        builder.to_xml
      end
    
      # Parse the XML response
      # @param [Net::HTTPResponse] api Instance of Clockwork::API
      # @return [string] XML data    
      def self.parse response
        if response.code.to_i == 200
          doc = Nokogiri.parse( response.body )
          doc.css('Credit').inner_html.to_i
        else
          raise Clockwork::HTTPError, "Could not connect to the Clockwork API to check credit."
        end
      end
      
    end
    
  end
end