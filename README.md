Clockwork SMS API Wrapper for Ruby
==================================

IMPORTANT
---------

Don't use this wrapper yet, it will not work until after the next Mediaburst SMS API release.

This README will be updated once that release has happened.

Install
-------

No gem is available yet, use the files directly by including them in your Ruby project.

Documentation
-------------

Full documentation is at [http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames][1]. Alternatively, run `yard doc` and open doc/index.html.

Usage
-----

Send a single SMS message:

    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    message = Clockwork::SMS.new( :to => '441234123456', :content => 'This is a test message.' )
    
    begin
        message.deliver
        # Do something with message.result
    rescue StandardError
        # Do something here
    end
    
Alternative usage:

    require 'clockwork'
    api = Clockwork::API.new( 'API_KEY_GOES_HERE' )
    message = Clockwork::SMS.new
    message.to = '441234123456'
    message.content = 'This is a test message.'
    
    begin
        message.deliver
        # Do something with message.result
    rescue StandardError
        # Do something here
    end

    
Send multiple SMS messages with advanced options set:

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
        message = Clockwork::SMS.new(m)
    
        begin
            message.deliver
            # Do something with message.result
        rescue StandardError
            # Do something here
        end
    end

Test Setup
----------

First, create a file at spec/spec_authentication_details.rb containing the following:

    34023ada3ec0d99213f91a12a2329ba932665ed7
    MyLegacyAPIUsername@mydomain.com
    MyPassword
    
Substitute your own API key, username and password on lines 1, 2, and 3 of the file.

Then, run `rspec`. 

License
-------

This project is licensed under the ISC open-source license.

A copy of this license can be found in LICENSE.

Contributing
------------

If you have any feedback on this wrapper drop us an email to [hello@clockworksms.com][2].

The project is hosted on GitHub at [http://www.github.com/mediaburst/clockwork-ruby][3].

If you would like to contribute a bug fix or improvement please fork the project 
and submit a pull request. Please add RSpec tests for your use case.

[1]: http://rubydoc.info/github/mediaburst/clockwork-ruby/master/frames
[2]: mailto:hello@clockworksms.com
[3]: http://www.github.com/mediaburst/clockwork-ruby