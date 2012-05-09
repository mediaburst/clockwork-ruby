module Clockwork
  module XML
    
    # @author James Inman <james@mediaburst.co.uk>
    # XML building and parsing for sending SMS messages.
    class SMS
      
      # Build the XML data to send a single SMS using the XML API.
      # @param [Clockwork::SMS] sms Instance of Clockwork::SMS
      # @return [string] XML data
      def self.build_single sms
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.Message {
            if sms.api.api_key
              xml.Key sms.api.api_key
            else
              xml.Username sms.api.username
              xml.Password sms.api.password                
            end
            xml.SMS {
              sms.translated_attributes.each do |k, v|
                xml.send "#{k}", v
              end
            }
          }
        end
        builder.to_xml
      end
      
      # Parse the XML data from a single SMS response from the XML API.
      # @param [Clockwork::SMS] sms Instance of Clockwork::SMS
      # @param [Net::HTTPResponse] http_response Instance of Net:HTTPResponse
      # @raise Clockwork:HTTPError - if a connection to the Clockwork API cannot be made
      # @return [Clockwork::SMS::Response] Instance of Clockwork::SMS::Response for the message
      def self.parse_single sms, http_response
        response = Clockwork::SMS::Response.new
        response.message = sms
        
        if http_response.code.to_i == 200
          doc = Nokogiri.parse( http_response.body )
          if doc.css('ErrDesc').empty?
            response.success = true
            response.message_id = doc.css('MessageID').inner_html
          else
            response.success = false
            response.error_code = doc.css('ErrNo').inner_html.to_i
            response.error_description = doc.css('ErrDesc').inner_html
          end
        else
          raise Clockwork::Error::HTTP, "Could not connect to the Clockwork API to send SMS."
        end
        
        response        
      end
      
    end
    
  end
end
