module Clockwork
  
  # @author James Inman <james@mediaburst.co.uk>
  # Use an instance of Clockwork::API#messages.build to create SMS messages.
  class MessageCollection
    
    # @!attribute api
    # An instance of Clockwork::API.
    # @return [Clockwork::API]
    attr_accessor :api
    
    # @!attribute messages
    # An array of Clockwork::SMS messages.
    # @return [array]    
    attr_accessor :messages
    
    # @param [hash] options Hash of attributes which must include an instance of Clockwork::API
    # @raise ArgumentError - if a valid instance of API is not passed as :api in options 
    # Create a new instance of Clockwork::MessageCollection.
    def initialize options
      @api = options[:api]
      raise ArgumentError, "Clockwork::MessageCollection#new must include an instance of Clockwork::API as :api" unless @api.kind_of?(Clockwork::API)
      
      @messages = []
    end
    
    # @param [hash] params Hash of parameters as attributes on Clockwork::SMS
    # @see Clockwork::SMS 
    # Create a new instance of Clockwork::SMS in this MessageCollection.
    def build params = {}
      sms = Clockwork::SMS.new({:api => @api}.merge(params))
      sms.wrapper_id = @messages.count
      @messages << sms
      sms
    end
    
  end
  
end
