module ClockworkSMS
  module XML
    
    # @author James Inman <james@mediaburst.co.uk>
    # XML building and parsing for checking credit.
    class Credit
      
      # Build the XML data to check the credit from the XML API.
      # @param [ClockworkSMS::API] api Instance of ClockworkSMS::API
      # @return [string] XML data
      def self.build api
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.Credit {
            if api.api_key
              xml.Key api.api_key
            else
              xml.Username api.username
              xml.Password api.password
            end
          }
        end
        builder.to_xml
      end
    
      # Parse the XML response.
      # @param [Net::HTTPResponse] response Instance of Net::HTTPResponse
      # @raise ClockworkSMS:HTTPError - if a connection to the ClockworkSMS API cannot be made
      # @raise ClockworkSMS::Error::Generic - if the API returns an error code other than 2
      # @raise ClockworkSMS::Error::Authentication - if API login details are incorrect
      # @return [string] Number of remaining credits    
      def self.parse response
        if response.code.to_i == 200
          doc = Nokogiri.parse( response.body )
          if doc.css('ErrDesc').empty?
            doc.css('Credit').inner_html.to_i
          elsif doc.css('ErrNo').inner_html.to_i == 2
            raise ClockworkSMS::Error::Authentication, doc.css('ErrDesc').inner_html
          else
            raise ClockworkSMS::Error::Generic, doc.css('ErrDesc').inner_html
          end
        else
          raise ClockworkSMS::Error::HTTP, "Could not connect to the ClockworkSMS API to check credit."
        end
      end
      
    end
    
  end
end