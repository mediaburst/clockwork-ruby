module Clockwork
  module XML

    # @author James Inman <james@mediaburst.co.uk>
    # XML building and parsing for checking balance.
    class Balance

      # Build the XML data to check the balance from the XML API.
      # @param [Clockwork::API] api Instance of Clockwork::API
      # @return [string] XML data
      def self.build api
        builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.Balance {
            if api.api_key
              xml.Key api.api_key
            else
              xml.Username api.username
              xml.Password api.password
            end
          }
        end
        builder.to_xml
      end

      # Parse the XML response.
      # @param [Net::HTTPResponse] response Instance of Net::HTTPResponse
      # @raise Clockwork:HTTPError - if a connection to the Clockwork API cannot be made
      # @raise Clockwork::Error::Generic - if the API returns an error code other than 2
      # @raise Clockwork::Error::Authentication - if API login details are incorrect
      # @return [string] Number of remaining credits
      def self.parse response
        if response.status == 200
          doc = Nokogiri.parse( response.body )
          if doc.css('ErrDesc').empty?
            hsh = {}
            hsh[:account_type] = doc.css('Balance_Resp').css('AccountType').inner_html
            hsh[:balance] = doc.css('Balance_Resp').css('Balance').inner_html.to_f
            hsh[:currency] = { :code  => doc.css('Balance_Resp').css('Currency').css('Code').inner_html, :symbol => doc.css('Balance_Resp').css('Currency').css('Symbol').inner_html }
            hsh
          elsif doc.css('ErrNo').inner_html.to_i == 2
            raise Clockwork::Error::Authentication, doc.css('ErrDesc').inner_html
          else
            raise Clockwork::Error::Generic, doc.css('ErrDesc').inner_html
          end
        else
          raise Clockwork::Error::HTTP, "Could not connect to the Clockwork API to check balance."
        end
      end

    end

  end
end
