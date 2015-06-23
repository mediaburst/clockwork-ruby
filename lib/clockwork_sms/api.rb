# A wrapper around the ClockworkSMS API.
module ClockworkSMS
    
  # Current API wrapper version
  VERSION = '1.2.1'
  
  # @author James Inman <james@mediaburst.co.uk>
  # You must create an instance of ClockworkSMS::API to begin using the API.
  class API
    
    # URL of the SMS API send action
    SMS_URL = "api.clockworksms.com/xml/send"
    # URL of the SMS API check credit action
    CREDIT_URL = "api.clockworksms.com/xml/credit"   
    # URL of the SMS API check balance action
    BALANCE_URL = "api.clockworksms.com/xml/balance"    
    
    # API key provided in ClockworkSMS::API#initialize.
    # @return [string] 
    attr_reader :api_key
    
    # This is the number of messages to concatenate (join together). 
    # @raise ArgumentError - if a value less than 2 or more than 3 is passed
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note Defaults to 3 if not set and ClockworkSMS::API#long is set to +true+.
    attr_reader :concat
        
    # @!attribute from
    # The from address displayed on a phone when the SMS is received. This can be either a 12 digit number or 11 characters long.
    # @return [string] 
    # @note This can be overriden for specific ClockworkSMS::SMS objects; if it is not set your account default will be used.
    attr_accessor :from
        
    # What to do with any invalid characters in the message content. +:error+ will raise a ClockworkSMS::InvalidCharacterException, +:replace+ will replace a small number of common invalid characters, such as the smart quotes used by Microsoft Office with a similar match, +:remove+ will remove invalid characters.
    # @raise ArgumentError - if value is not one of +:error+, +:replace+, +:remove+
    # @return [symbol] One of +error+, +:replace+, +:remove+ 
    # @note This can be overriden for specific ClockworkSMS::SMS objects; if it is not set your account default will be used.
    attr_reader :invalid_char_action
        
    # @!attribute long
    # Set to +true+ to enable long SMS. A standard text can contain 160 characters, a long SMS supports up to 459. Each recipient will cost up to 3 message credits.
    # @return [boolean]
    # @note This can be overriden for specific ClockworkSMS::SMS objects; if it is not set your account default will be used.
    attr_accessor :long
    
    # @!attribute messages
    # Returns a ClockworkSMS::MessageCollection containing all built SMS messages.
    # @return [ClockworkSMS::MessageCollection]
    attr_reader :messages
    
    # Password provided in ClockworkSMS::API#initialize.
    # @return [string]
    # @deprecated Use api_key instead.
    attr_reader :password
    
    # @!attribute truncate
    # Set to +true+ to trim the message content to the maximum length if it is too long.
    # @return [boolean] 
    # @note This can be overriden for specific ClockworkSMS::SMS objects; if it is not set your account default will be used.
    attr_accessor :truncate

    # Whether to use SSL when connecting to the API.
    # Defaults to +true+
    # @return [boolean] 
    attr_accessor :use_ssl
    
    # Username provided in ClockworkSMS::API#initialize.
    # @return [string]
    # @deprecated Use api_key instead.
    attr_reader :username
        
    # Alias for ClockworkSMS::API#credit to preserve backwards compatibility with original Mediaburst API.
    # @deprecated Use ClockworkSMS::API#credit. Support for ClockworkSMS::API#get_credit will be removed in a future version of this wrapper.
    def get_credit
      credit
    end
      
    def invalid_char_action= symbol
      raise( ArgumentError, "#{symbol} must be one of :error, :replace, :remove" ) unless [:error, :remove, :replace].include?(symbol.to_sym)
      @invalid_char_action = [nil, :error, :remove, :replace].index(symbol.to_sym)
    end
    
    def concat= number
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
    # @raise ClockworkSMS::Error::InvalidAPIKey - if API key is invalid
    # ClockworkSMS::API is initialized with an API key, available from http://www.mediaburst.co.uk/api.
    def initialize *args
      if args.size == 1 || ( args.size == 2 && args[1].kind_of?(Hash) ) 
        raise ClockworkSMS::Error::InvalidAPIKey unless args[0][/^[A-Fa-f0-9]{40}$/]
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
      @messages ||= ClockworkSMS::MessageCollection.new( :api => self )
      @invalid_char_action = [nil, :error, :remove, :replace].index(@invalid_char_action) if @invalid_char_action
      @truncate = @truncate ? true : false unless @truncate.nil?
    end
    
    # Check the remaining credit for this account.
    # @raise ClockworkSMS::Error::Authentication - if API login details are incorrect
    # @return [integer] Number of messages remaining    
    def credit
      xml = ClockworkSMS::XML::Credit.build( self )
      response = ClockworkSMS::HTTP.post( ClockworkSMS::API::CREDIT_URL, xml, @use_ssl )
      credit = ClockworkSMS::XML::Credit.parse( response )
    end
    
    # Check the remaining credit for this account.
    # @raise ClockworkSMS::Error::Authentication - if API login details are incorrect
    # @return [integer] Number of messages remaining    
    def balance
      xml = ClockworkSMS::XML::Balance.build( self )
      response = ClockworkSMS::HTTP.post( ClockworkSMS::API::BALANCE_URL, xml, @use_ssl )
      balance = ClockworkSMS::XML::Balance.parse( response )
    end
    
    # Deliver multiple messages created using ClockworkSMS::API#messages.build.
    # @return [array] Array of ClockworkSMS::SMS::Response objects for messages.
    def deliver
      xml = ClockworkSMS::XML::SMS.build_multiple( self.messages )
      http_response = ClockworkSMS::HTTP.post( ClockworkSMS::API::SMS_URL, xml, @use_ssl )
      responses = ClockworkSMS::XML::SMS.parse_multiple( self.messages, http_response )
    end
    
  end
  
end