# A wrapper around the Clockwork API.
module Clockwork
    
  # Current API wrapper version
  VERSION = 'DEV'
  
  # @author James Inman <james@mediaburst.co.uk>
  # 
  # You must create an instance of Clockwork::API to begin using the API.
  class API
    
    # URL of the SMS API send action
    SMS_URL = "api.clockworksms.com/xml/send"
    # URL of the SMS API check credit action
    CREDIT_URL = "api.clockworksms.com/xml/credit"
    
    # Alias for Clockwork::API#messages_to_concat to preserve backwards compatibility with original Mediaburst API.
    # @deprecated Use Clockwork::API#messages_to_concat instead. Support for Clockwork::API#concat will be removed in a future version of this wrapper.
    alias :concat= :messages_to_concat=
    
    # API key provided in Clockwork::API#initialize.
    # @return [string] 
    attr_reader :api_key
        
    # @!attribute from
    # The from address displayed on a phone when the SMS is received. This can be either a 12 digit number or 11 characters long.
    # @return [string] 
    # @note This can be overriden for specific Clockwork::SMS objects; if it is not set your account default will be used.
    attr_accessor :from
        
    # What to do with any invalid characters in the message content. +:error+ will raise a Clockwork::InvalidCharacterException, +:replace+ will replace a small number of common invalid characters, such as the smart quotes used by Microsoft Office with a similar match, +:remove+ will remove invalid characters.
    # @raise ArgumentError - if value is not one of +:error+, +:replace+, +:remove+
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note This can be overriden for specific Clockwork::SMS objects; if it is not set your account default will be used.
    attr_reader :invalid_char_action
    
    # If Clockwork::API#long is set to +true+, this is the number of messages to concatenate (join together). 
    # @raise ArgumentError - if a value less than 2 or more than 3 is passed
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note Defaults to 3 if not set and Clockwork::API#long is set to +true+.
    attr_reader :messages_to_concat
        
    # @!attribute long
    # Set to +true+ to enable long SMS. A standard text can contain 160 characters, a long SMS supports up to 459. Each recipient will cost up to 3 message credits.
    # @return [boolean]
    # @note This can be overriden for specific Clockwork::SMS objects; if it is not set your account default will be used.
    attr_accessor :long
    
    # Password provided in Clockwork::API#initialize.
    # @return [string]
    # @deprecated Use api_key instead.
    attr_reader :password
    
    # @!attribute truncate
    # Set to +true+ to trim the message content to the maximum length if it is too long.
    # @return [boolean] 
    # @note This can be overriden for specific Clockwork::SMS objects; if it is not set your account default will be used.
    attr_accessor :truncate
    
    # Whether to use SSL when connecting to the API.
    # Defaults to +true+
    # @return [boolean] 
    attr_accessor :use_ssl
    
    # Username provided in Clockwork::API#initialize.
    # @return [string]
    # @deprecated Use api_key instead.
    attr_reader :username
      
    def invalid_char_action= symbol
      raise( ArgumentError, "#{symbol} must be one of :error, :replace, :remove" ) unless [:error, :replace, :remove].include?(symbol.to_sym)
    end
    
    def messages_to_concat= number
      raise( ArgumentError, "#{number} must be either 2 or 3" ) unless [2, 3].include?(number.to_i)
    end
    
    # @overload initalize(api_key)
    #   @param [string] api_key API key, 40-character hexadecimal string
    #   @param [hash] options Optional hash of attributes on API 
    # @overload initalize(username, password)
    #   @param [string] username Your API username
    #   @param [string] password Your API password
    #   @param [hash] options Optional hash of attributes on API
    #   @deprecated Use an API key instead. Support for usernames and passwords will be removed in a future version of this wrapper.
    # @raise ArgumentError - if more than 3 parameters are passed
    # @raise Clockwork::InvalidAPIKeyError - if API key is invalid
    # Clockwork::API is initialized with an API key, available from http://www.mediaburst.co.uk/api.
    def initialize *args
      if args.size == 1 || ( args.size == 2 && args[1].kind_of?(Hash) ) 
        raise Clockwork::InvalidAPIKeyError unless args[0][/^[A-Fa-f0-9]{40}$/]
        @api_key = args[0]
      elsif args.size == 2 || ( args.size == 3 && args[2].kind_of?(Hash) ) 
        raise ArgumentError, "You must pass both a username and password." if args[0].empty? || args[1].empty?
        @username = args[0]
        @password = args[1]
      else
        raise ArgumentError, "You must pass either an API key OR a username and password."
      end
      
      args.last.each { |k, v| instance_variable_set "@#{k}", v } if args.last.kind_of?(Hash)
      
      @use_ssl = true if @use_ssl.nil?
      @concat = 3 if @concat.nil? && @long
    end
    
    # Check the remaining credit for this account.
    # @raise Clockwork::AuthenticationError - if API login details are incorrect
    # @return [integer] Number of messages remaining    
    def credit
      xml = Clockwork::XML::Credit.build( self )
      response = Clockwork::HTTP.post( CREDIT_URL, xml, @use_ssl )
      credit = Clockwork::XML::Credit.parse( response )
    end
     
    # Alias for Clockwork::API#credit to preserve backwards compatibility with original Mediaburst API.
    # @deprecated Use Clockwork::API#credit. Support for Clockwork::API#get_credit will be removed in a future version of this wrapper.
    def get_credit
      credit
    end
    
    # Alias for Clockwork::SMS#deliver to preserve backwards compatibility with original Mediaburst API.
    # @deprecated Use Clockwork::SMS#deliver. Support for Clockwork::API#send_message will be removed in a future version of this wrapper.  
    # @overload send_message(number, message, options)
    #   @param [string] number The phone number to send the SMS to in international number format (without a leading + or international dialling prefix such as 00, e.g. 441234567890).
    #   @param [string] message The message content to send.
    #   @param [hash] options Optional hash of attributes on Clockwork::SMS 
    # @overload send_message(numbers, message, options)
    #   @param [array] numbers Array of string phone numbers to send the SMS to in international number format (without a leading + or international dialling prefix such as 00, e.g. 441234567890).
    #   @param [string] message The message content to send.
    #   @param [hash] options Optional hash of attributes on Clockwork::SMS 
    # @return [hash] Hash in the format "phone number" => true on success, or "phone number" => error_number on failure.
    def send_message *args
    end
    
  end
  
end