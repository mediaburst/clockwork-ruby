Gem::Specification.new do |s|
  s.name = "clockworksms"
  s.version = "1.0.0"
  s.author = "Mediaburst"
  s.email = "hello@mediaburst.co.uk"
  s.homepage = "http://www.clockworksms.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby Gem for the Clockwork API."
  s.description = "Ruby Gem for the Clockwork API. Send text messages with the easy to use SMS API from Mediaburst."
  s.files = Dir["lib/**/*.rb"] + Dir["[A-Z]*"]

  s.add_dependency "nokogiri", "~> 1.5.2"

  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rspec"
  s.has_rdoc = true
end
