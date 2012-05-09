# Clockwork SMS API Wrapper for Ruby

# IMPORTANT

Don't use this wrapper yet, it will not work until after the next Mediaburst SMS API release.

This README will be updated once that release has happened.

Still to do:
* Split-testing for more than 500 messages
* Net::HTTP::Proxy settings

## Install

No gem is available yet, use the files directly by including them in your Ruby project.

## Documentation

Full documentation is at [http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames][1]. Alternatively, run `yard doc` and open doc/index.html.

## Usage

For more information on the available optional parameters for the API (Clockwork::API), see [here][4].

For more information on the available optional parameters for each SMS (Clockwork::SMS), see [here][5]. For more information on the response object returned from each SMS (Clockwork::SMS::Response), see [here][6].

### Send a single SMS message

    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    message = api.messages.build( :to => '441234123456', :content => 'This is a test message.' )
    response = message.deliver
    
    if response.success
        puts response.message_id
    else
        puts response.error_code
        puts response.error_description
    end
    
### Alternative usage for sending an SMS message

    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    
    message = api.messages.build
    message.to = '441234123456'
    message.content = 'This is a test message.'
    response = message.deliver
    
    if response.success
        puts response.message_id
    else
        puts response.error_code
        puts response.error_description
    end
    
### Send multiple SMS messages with an optional client ID

You should not use the `deliver` method for each message, but instead use the `Clockwork::API#deliver_messages` method to send multiple messages in the same API request. This will decrease load on the API and ensure your requests are processed faster.

    messages = [
        { :to => '441234123456', :content => 'This is a test message.', :client_id => '1' },
        { :to => '441234123456', :content => 'This is a test message 2.', :client_id => '2' },
        { :to => '441234123456', :content => 'This is a test message 3.', :client_id => '3' },
        { :to => '441234123456', :content => 'This is a test message 4.', :client_id => '4' },
        { :to => '441234123456', :content => 'This is a test message 5.', :client_id => '5' },
        { :to => '441234123456', :content => 'This is a test message 6.', :client_id => '6' }
    ]
    
    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    messages.each do |m|
        api.messages.build(m)
    end
    
    responses = api.deliver_messages
    responses.each do |response|
        puts response.client_id
        if response.success
            puts response.message_id
        else
            puts response.error_code
            puts response.error_description
        end
    end
    
### Check credit
    
    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    remaining_messages = Clockwork::API.credit
    puts remaining messages # => 240
    
## Notes

**Backwards Compatibility:** This API is entirely backwards compatible with the legacy *ruby-mediaburst-sms* gem - simply replace 'Mediaburst' with 'Clockwork' in your code that uses the library. However, we strongly recommend you update your code to use the above examples.

## License

This project is licensed under the ISC open-source license.

A copy of this license can be found in LICENSE.

## Contributing

If you have any feedback on this wrapper drop us an email to [hello@clockworksms.com][2].

The project is hosted on GitHub at [http://www.github.com/mediaburst/clockwork-ruby][3].

If you would like to contribute a bug fix or improvement please fork the project 
and submit a pull request. Please add RSpec tests for your use case.

### Test Setup

First, create a file at spec/spec_authentication_details containing the following:

    34023ada3ec0d99213f91a12a2329ba932665ed7
    MyLegacyAPIUsername@mydomain.com
    MyPassword
    
Substitute your own API key, username and password on lines 1, 2, and 3 of the file.

Then, run `rspec`. 

[1]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames
[2]: mailto:hello@clockworksms.com
[3]: http://www.github.com/mediaburst/clockwork-ruby
[4]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/API
[5]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/SMS
[6]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/SMS/Response