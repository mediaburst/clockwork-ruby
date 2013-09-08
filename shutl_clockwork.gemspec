require 'rake'

Gem::Specification.new do |s|
  s.name = "shutl-clockworksms"
  s.version = "1.0.1"
  s.author = "Mediaburst"
  s.email = "hello@mediaburst.co.uk"
  s.homepage = "http://www.clockworksms.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby Gem for the Clockwork API."
  s.description = "Ruby Gem for the Clockwork API. Send text messages with the easy to use SMS API from Mediaburst."
  s.files = FileList["lib/**/*.rb", "[A-Z]*"].to_a

  s.add_dependency             "faraday"
  s.add_dependency             "nokogiri"

  s.add_development_dependency "needy_debugger"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.has_rdoc = true
end