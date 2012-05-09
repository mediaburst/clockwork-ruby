module Clockwork
  
  # @author James Inman <james@mediaburst.co.uk>
  # Use an instance of Clockwork::API#messages.build to create SMS messages.
  class MessageCollection
    
    # @!attribute api
    # An instance of Clockwork::API.
    # @return [Clockwork::API]
    attr_accessor :api
    
    # @param [hash] options Hash of attributes which must include an instance of Clockwork::API
    # @raise ArgumentError - if a valid instance of API is not passed as :api in options 
    # Create a new instance of Clockwork::MessageCollection.
    def initialize options
      @api = options[:api]
      raise ArgumentError, "Clockwork::MessageCollection#new must include an instance of Clockwork::API as :api" unless @api.kind_of?(Clockwork::API)
    end
    
    # @param [hash] params Hash of parameters as attributes on Clockwork::SMS
    # @see Clockwork::SMS 
    # Create a new instance of Clockwork::SMS in this MessageCollection.
    def build params = {}
      Clockwork::SMS.new({ api: @api }.merge(params))
    end
    
  end
  
end
