Gem::Specification.new do |s|
  s.name = "clockworksms"
  s.version = "1.2.1"
  s.author = "Mediaburst"
  s.email = "hello@mediaburst.co.uk"
  s.homepage = "http://www.clockworksms.com/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby Gem for the Clockwork API."
  s.description = "Ruby Gem for the Clockwork API. Send text messages with the easy to use SMS API from Mediaburst."
  s.files = Dir["lib/**/*.rb"] + Dir["[A-Z]*"]
  s.licenses = ['MIT']
  s.add_dependency "nokogiri", "~> 1.5.2"
  s.add_dependency "faraday", "~> 0.8"
  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rspec", "~> 3.1"
  s.has_rdoc = true
end
