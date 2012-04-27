lib_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'clockwork/api'
require 'clockwork/sms'