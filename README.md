# Clockwork SMS API Ruby Gem
[![Gem Version](https://badge.fury.io/rb/clockworksms.svg)](http://badge.fury.io/rb/clockworksms)
## Install

Just add the following to your Gemfile:

    gem 'clockworksms'

## Documentation

Full documentation is at [http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames][1]. Alternatively, run `yard doc` and open doc/index.html.

## Usage

For more information on the available optional parameters for the API (ClockworkSMS::API), see [here][4].

For more information on the available optional parameters for each SMS (ClockworkSMS::SMS), see [here][5]. For more information on the response object returned from each SMS (ClockworkSMS::SMS::Response), see [here][6].

### Send a single SMS message

```ruby
require 'clockwork'
api = ClockworkSMS::API.new( 'API_KEY_GOES_HERE' )
message = api.messages.build( :to => '441234123456', :content => 'This is a test message.' )
response = message.deliver
    
if response.success
    puts response.message_id
else
    puts response.error_code
    puts response.error_description
end
```

### Alternative usage for sending an SMS message

```ruby
require 'clockwork'
api = ClockworkSMS::API.new( 'API_KEY_GOES_HERE' )
    
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
```

### Send multiple SMS messages (with an optional client ID)

You should not use the `ClockworkSMS::Message#deliver` method for each message, but instead use the `ClockworkSMS::API#deliver` method to send multiple messages in the same API request. This will decrease load on the API and ensure your requests are processed significantly faster.

```ruby

messages = [
    { :to => '441234123456', :content => 'This is a test message.', :client_id => '1' },
    { :to => '441234123456', :content => 'This is a test message 2.', :client_id => '2' },
    { :to => '441234123456', :content => 'This is a test message 3.', :client_id => '3' },
    { :to => '441234123456', :content => 'This is a test message 4.', :client_id => '4' },
    { :to => '441234123456', :content => 'This is a test message 5.', :client_id => '5' },
    { :to => '441234123456', :content => 'This is a test message 6.', :client_id => '6' }
]

require 'clockwork'
api = ClockworkSMS::API.new( 'API_KEY_GOES_HERE' )
messages.each do |m|
    api.messages.build(m)
end

responses = api.deliver
responses.each do |response|
    puts response.message.client_id
    if response.success
        puts response.message_id
    else
        puts response.error_code
        puts response.error_description
    end
end
```
    
### Check balance
    
```ruby
require 'clockwork'
api = ClockworkSMS::API.new( 'API_KEY_GOES_HERE' )
balance = ClockworkSMS::API.balance
puts balance # => { :account_type => "PAYG", :balance => 575.23, :currency => { :code => "GBP", :symbol => "£" } }
```

## Help & Support

If you find a bug please file a Github issue with as much detail as you can or submit a pull request. If you need a bit of help or just fancy a chat drop us an email at [hello@clockworksms.com][2].

## License

This project is licensed under the MIT open-source license.

A copy of this license can be found in LICENSE.

## Contributing

If you have any feedback on this wrapper drop us an email to [hello@clockworksms.com][2].

The project is hosted on GitHub at [http://www.github.com/mediaburst/clockwork-ruby][3].

If you would like to contribute a bug fix or improvement please fork the project 
and submit a pull request. Please add RSpec tests for your use case.

If we don't respond to your bug report or pull request within a few days please email [hello@clockworksms.com][2] or remind [@ClockworkSMS on Twitter][7], we probably haven't spotted the notification.

### Test Setup

First, create a file at spec/spec_authentication_details containing the following:

    YOUR_API_KEY_HERE
    
Substitute your own API key on line 1 of the file and replace the telephone numbers in the spec files with your own.

Then, run `rspec`. 

## Changelog

### 1.0.0 (18th July, 2012)

* Initial release of wrapper [JI]

### 1.1.0 (10th September, 2012)

* API#credit is now deprecated: use API#balance instead.

### 1.2.0 (30th June, 2014)

* Compatability fixes for Ruby 1.8, 2.0 and 2.1 (Tested with 1.8.7-p375, 1.9.3-p547, 2.0.0-p481 and 2.1.2).
Thanks to [Paul Volpato](https://github.com/volpe), [Todd Bealmear](https://github.com/todd) and [Fawad](https://github.com/fawad) for the pull requests.

### 1.2.1 (28th September, 2014)

* Add some tests for the invalid_char_action and truncate parameters.
* Fix invalid_char_action parameter as it was passing invalid values to the Clockwork API.
Thanks to [Tom Pesman](https://github.com/tompesman) for the fix.


[1]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames
[2]: mailto:hello@clockworksms.com
[3]: http://www.github.com/mediaburst/clockwork-ruby
[4]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/API
[5]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/SMS
[6]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/Clockwork/SMS/Response
[7]: http://twitter.com/ClockworkSMS
