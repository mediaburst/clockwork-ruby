# A wrapper around the Clockwork API.
module Clockwork
  
  # @author James Inman <james@mediaburst.co.uk>
  # 
  # Create an instance of Clockwork::SMS for each SMS message you want to send.
  class SMS
    
    # @!group Optional Attributes
        
    # @!attribute client_id
    # A unique message ID specified by the connecting application, for example your database record ID. Maximum length: 50 characters.
    # @return [string]
    attr_accessor :client_id
        
    # @!attribute from
    # The from address displayed on a phone when the SMS is received. This can be either a 12 digit number or 11 characters long.
    # @return [string] 
    # @note If this option is set it overrides the global option specified in Clockwork::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :from
    
    # @!attribute long
    # Set to +true+ to enable long SMS. A standard text can contain 160 characters, a long SMS supports up to 459. Each recipient will cost up to 3 message credits.
    # @return [boolean]
    # @note If this option is set it overrides the global option specified in Clockwork::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :long
    
    # @!attribute truncate
    # Set to +true+ to trim the message content to the maximum length if it is too long.
    # @return [boolean] 
    # @note If this option is set it overrides the global option specified in Clockwork::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :truncate
        
    # What to do with any invalid characters in the message content. +:error+ will raise a Clockwork::InvalidCharacterException, +:replace+ will replace a small number of common invalid characters, such as the smart quotes used by Microsoft Office with a similar match, +:remove+ will remove invalid characters.
    # @raise ArgumentError - if value is not one of +:error+, +:replace+, +:remove+
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note If this option is set it overrides the global option specified in Clockwork::API for this SMS, if neither option is set your account default will be used.
    attr_reader :invalid_char_action
    
    # #!@endgroup
    
    # @!group Required Attributes
    
    # @!attribute to
    # The phone number to send the SMS to. This should be a phone number in international number format without a leading + or international dialling prefix such as 00, e.g. 441234567890.
    # @return [string]
    attr_accessor :to
    
    # #!@endgroup
    
    
    def initialize
    end
    
    def invalid_char_action= symbol
      raise( ArgumentError, "#{symbol} must be one of :error, :replace, :remove" ) unless [:error, :replace, :remove].include?(symbol.to_sym)
    end    
    
  end
  
end
