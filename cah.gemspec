Gem::Specification.new do |s|
  s.name = "cah"
  s.version = "0.0.1"
  s.description = 'Cards Against Humanity'
  s.summary = 'Cards Against Humanity'

  s.license = "MIT"

  s.authors = ["Kyle Rippey", "Jeff Ching"]
  s.email = "kylerippey@gmail.com"
  s.homepage = "http://github.com/kylerippey/cah"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir.glob('test/*_test.rb')
end
