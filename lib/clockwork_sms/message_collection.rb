module ClockworkSMS
  
  # @author James Inman <james@mediaburst.co.uk>
  # Use an instance of ClockworkSMS::API#messages.build to create SMS messages.
  class MessageCollection
    
    # @!attribute api
    # An instance of ClockworkSMS::API.
    # @return [ClockworkSMS::API]
    attr_accessor :api
    
    # @!attribute messages
    # An array of ClockworkSMS::SMS messages.
    # @return [array]    
    attr_accessor :messages
    
    # @param [hash] options Hash of attributes which must include an instance of ClockworkSMS::API
    # @raise ArgumentError - if a valid instance of API is not passed as :api in options 
    # Create a new instance of ClockworkSMS::MessageCollection.
    def initialize options
      @api = options[:api]
      raise ArgumentError, "ClockworkSMS::MessageCollection#new must include an instance of ClockworkSMS::API as :api" unless @api.kind_of?(ClockworkSMS::API)
      
      @messages = []
    end
    
    # @param [hash] params Hash of parameters as attributes on ClockworkSMS::SMS
    # @see ClockworkSMS::SMS
    # Create a new instance of ClockworkSMS::SMS in this MessageCollection.
    def build params = {}
      sms = ClockworkSMS::SMS.new({ :api => @api }.merge(params))
      sms.wrapper_id = @messages.count
      @messages << sms
      sms
    end
    
  end
  
end
