lib_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'net/http'
require 'faraday'
require 'nokogiri'

require 'clockwork/error'
require 'clockwork/http'
require 'clockwork/xml/xml'

require 'clockwork/message_collection'
require 'clockwork/api'
require 'clockwork/sms'
require 'clockwork/sms/response'
