Gem::Specification.new do |s|
  s.name = "clockwork"
  s.version = "0.0.1"
  s.author = "James Inman"
  s.email = "james@mediaburst.co.uk"
  s.homepage = "http://www.mediaburst.co.uk/api/" 
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby wrapper for the Clockwork API."
  s.files = FileList["lib/**/*.rb", "[A-Z]*"].to_a

  s.add_development_dependency "rake-compiler"
  s.add_development_dependency "rspec"
  s.has_rdoc = true
end