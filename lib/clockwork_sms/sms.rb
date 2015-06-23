module ClockworkSMS
  
  # @author James Inman <james@mediaburst.co.uk>
  # Create an instance of ClockworkSMS::SMS for each SMS message you want to send.
  class SMS
    
    # @!attribute api
    # An instance of ClockworkSMS::API.
    # @return [ClockworkSMS::API]
    attr_accessor :api
    
    # @!attribute content
    # *REQUIRED:* The message content to send.
    # @return [string]
    attr_accessor :content
            
    # @!attribute client_id
    # An unique message ID specified by the connecting application, for example your database record ID. Maximum length: 50 characters.
    # @return [string]
    attr_accessor :client_id
        
    # @!attribute from
    # The from address displayed on a phone when the SMS is received. This can be either a 12 digit number or 11 characters long.
    # @return [string] 
    # @note If this option is set it overrides the global option specified in ClockworkSMS::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :from
    
    # @!attribute long
    # Set to +true+ to enable long SMS. A standard text can contain 160 characters, a long SMS supports up to 459. Each recipient will cost up to 3 message credits.
    # @return [boolean]
    # @note If this option is set it overrides the global option specified in ClockworkSMS::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :long
    
    # @!attribute truncate
    # Set to +true+ to trim the message content to the maximum length if it is too long.
    # @return [boolean] 
    # @note If this option is set it overrides the global option specified in ClockworkSMS::API for this SMS, if neither option is set your account default will be used.
    attr_accessor :truncate

    # What to do with any invalid characters in the message content. +:error+ will raise a ClockworkSMS::InvalidCharacterException, +:replace+ will replace a small number of common invalid characters, such as the smart quotes used by Microsoft Office with a similar match, +:remove+ will remove invalid characters.
    # @raise ArgumentError - if value is not one of +:error+, +:replace+, +:remove+
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note If this option is set it overrides the global option specified in ClockworkSMS::API for this SMS, if neither option is set your account default will be used.
    attr_reader :invalid_char_action
    
    # @!attribute to
    # *REQUIRED:* The phone number to send the SMS to in international number format (without a leading + or international dialling prefix such as 00, e.g. 441234567890).
    # @return [string]
    attr_accessor :to
    
    attr_writer :wrapper_id
    
    def invalid_char_action= symbol
      raise( ArgumentError, "#{symbol} must be one of :error, :replace, :remove" ) unless [:error, :remove, :replace].include?(symbol.to_sym)
    end    
    
    # @param [hash] options Optional hash of attributes on ClockworkSMS::SMS
    # Create a new SMS message.
    def initialize options = {}      
      options.each { |k, v| instance_variable_set "@#{k}", v } if options.kind_of?(Hash)
      @invalid_char_action = [nil, :error, :remove, :replace].index(@invalid_char_action) if @invalid_char_action
      @truncate = @truncate ? true : false unless @truncate.nil?
    end
    
    # Deliver the SMS message.
    # @return [ClockworkSMS::SMS::Response] An instance of ClockworkSMS::SMS::Response
    def deliver
      xml = ClockworkSMS::XML::SMS.build_single( self )
      http_response = ClockworkSMS::HTTP.post( ClockworkSMS::API::SMS_URL, xml, @api.use_ssl )
      response = ClockworkSMS::XML::SMS.parse_single( self, http_response )
    end
    
    # Translate standard variable names to those needed to make an XML request. First, checks if global variables are set in ClockworkSMS::API then overwrites with variables set in ClockworkSMS::SMS instance.
    # @return [hash] Hash of XML keys and values
    def translated_attributes
      attributes = {}
      translations = []
      translations << { :var => 'client_id', :xml_var => 'ClientID' }
      translations << { :var => 'concat', :xml_var => 'Concat' }
      translations << { :var => 'from', :xml_var => 'From' }
      translations << { :var => 'invalid_char_action', :xml_var => 'InvalidCharAction' }
      translations << { :var => 'content', :xml_var => 'Content' }
      translations << { :var => 'to', :xml_var => 'To' }
      translations << { :var => 'truncate', :xml_var => 'Truncate' }
      translations << { :var => 'wrapper_id', :xml_var => 'WrapperID' }
      
      translations.each do |t|
        self.instance_variable_set( "@#{t[:var]}", @api.instance_variable_get( "@#{t[:var]}" ) ) if self.instance_variable_get( "@#{t[:var]}" ).nil?
        attributes[ t[:xml_var] ] = self.instance_variable_get( "@#{t[:var]}" ) unless self.instance_variable_get( "@#{t[:var]}" ).nil?
      end

      attributes
    end 
    
  end
  
end
