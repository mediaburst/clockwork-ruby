require 'nokogiri'

module Clockwork

  # @author James Inman <james@mediaburst.co.uk>
  # Wrapper for the XML builder/parser
  module XML        
  end
  
end

# Require everything in this directory
dir_path = File.dirname(__FILE__)
Dir["#{dir_path}/*.rb"].each do |file|
  next if file =~ /xml.rb$/
  require file
end