lib_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'net/http'
require 'nokogiri'

require 'clockwork/error'
require 'clockwork/http'
require 'clockwork/xml/xml'

require 'clockwork/api'
require 'clockwork/sms'