module Clockwork
  
  # Raised if the entered authentication details (API key or username and password) are incorrect.
  class AuthenticationError < StandardError
  end
  
  # Raised if a HTTP connection to the API fails
  class HTTPError < StandardError
  end
  
  # Raised if the API key is in an invalid format.
  class InvalidAPIKeyError < StandardError
  end
  
end
