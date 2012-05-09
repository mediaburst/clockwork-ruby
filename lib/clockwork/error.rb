module Clockwork
  
  # Module containing Clockwork::Error classes, all of which extend StandardError.
  module Error

    # @author James Inman <james@mediaburst.co.uk>
    # Raised if the entered authentication details (API key or username and password) are incorrect. (Error code: 2)
    class Authentication < StandardError
    end
  
    # @author James Inman <james@mediaburst.co.uk>
    # Raised for all error codes not otherwise specified.
    class Generic < StandardError
    end
  
    # @author James Inman <james@mediaburst.co.uk>
    # Raised if a HTTP connection to the API fails.
    class HTTP < StandardError
    end
  
    # @author James Inman <james@mediaburst.co.uk>
    # Raised if the API key is in an invalid format.
    class InvalidAPIKey < StandardError
    end
    
  end
  
end
