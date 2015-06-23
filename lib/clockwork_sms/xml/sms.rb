module ClockworkSMS
  module XML
    
    # @author James Inman <james@mediaburst.co.uk>
    # XML building and parsing for sending SMS messages.
    class SMS
      
      # Build the XML data to send a single SMS using the XML API.
      # @param [ClockworkSMS::SMS] sms Instance of ClockworkSMS::SMS
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
      
      # Build the XML data to send multiple SMS messages using the XML API.
      # @param [ClockworkSMS::MessageCollection] collection Instance of ClockworkSMS::SMS
      # @return [string] XML data
      def self.build_multiple collection
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.Message {
            if collection.api.api_key
              xml.Key collection.api.api_key
            else
              xml.Username collection.api.username
              xml.Password collection.api.password                
            end
            collection.messages.each do |sms|
              xml.SMS {
                sms.translated_attributes.each do |k, v|
                  xml.send "#{k}", v
                end
              }
            end
          }
        end
        builder.to_xml
      end
      
      # Parse the XML data from a single SMS response from the XML API.
      # @param [ClockworkSMS::SMS] sms Instance of ClockworkSMS::SMS
      # @param [Net::HTTPResponse] http_response Instance of Net:HTTPResponse
      # @raise ClockworkSMS:HTTPError - if a connection to the ClockworkSMS API cannot be made
      # @return [ClockworkSMS::SMS::Response] Instance of ClockworkSMS::SMS::Response for the message
      def self.parse_single sms, http_response
        response = ClockworkSMS::SMS::Response.new
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
          raise ClockworkSMS::Error::HTTP, "Could not connect to the ClockworkSMS API to send SMS."
        end
        
        response        
      end

      # Parse the XML data from a multiple SMS response from the XML API.
      # @param [ClockworkSMS::MessageCollection] collection Instance of ClockworkSMS::SMS
      # @param [Net::HTTPResponse] http_response Instance of Net:HTTPResponse
      # @raise ClockworkSMS:HTTPError - if a connection to the ClockworkSMS API cannot be made
      # @return [array] Array of ClockworkSMS::SMS::Response objects relating to the messages
      def self.parse_multiple collection, http_response
        responses = []
        
        if http_response.code.to_i == 200
          doc = Nokogiri.parse( http_response.body )
        else
          raise ClockworkSMS::Error::HTTP, "Could not connect to the ClockworkSMS API to send SMS."
        end
        
        doc.css('SMS_Resp').each_with_index do |sms_response, i|
          response = ClockworkSMS::SMS::Response.new
          response.message = collection.messages[i]
          if sms_response.css('ErrDesc').empty?
            response.success = true
            response.message_id = sms_response.css('MessageID').inner_html
          else
            response.success = false
            response.error_code = sms_response.css('ErrNo').inner_html.to_i
            response.error_description = sms_response.css('ErrDesc').inner_html
          end
          responses[sms_response.css('WrapperID').inner_html.to_i] = response
        end
        
        responses
      end
      
    end
    
  end
end
