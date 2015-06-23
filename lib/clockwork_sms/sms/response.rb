module ClockworkSMS
  class SMS
    
    # @author James Inman <james@mediaburst.co.uk>
    # A ClockworkSMS::SMS::Response is returned for each SMS sent by ClockworkSMS::SMS#deliver.
    class Response
        
      # @!attribute error_code
      # The error code returned if the SMS fails.
      # @return [string] 
      attr_accessor :error_code
      
      # @!attribute error_description
      # The error description returned if the SMS fails.
      # @return [string] 
      attr_accessor :error_description
        
      # @!attribute message_id
      # The message ID returned if the SMS is sent successfully.
      # @return [string] 
      attr_accessor :message_id
        
      # @!attribute message
      # The instance of ClockworkSMS::SMS relating to this response.
      # @return [ClockworkSMS::SMS]
      attr_accessor :message
        
      # @!attribute success
      # +true+ if the SMS is sent successfully, +false+ otherwise.
      # @return [boolean] 
      attr_accessor :success
      
      def error_code
        @error_code.to_i unless @error_code.nil?
      end
      
    end    
  end  
end
