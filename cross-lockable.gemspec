$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cross_lockable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cross-lockable"
  s.version     = CrossLockable::VERSION
  s.authors     = ["Gustavo Kloh", "Vicente Mundim", "Luis Vasconcellos", "Otavio Cardoso"]
  s.email       = ["gustavo.kloh@dtmtec.com.br", "vicente.mundim@dtmtec.com.br", "luis.vasconcellos@dtmtec.com.br", "otavio.cardoso@dtmtec.com.br"]
  s.homepage    = "http://dtmtec.com.br"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "sass-rails"
  s.add_dependency "compass-rails"
  s.add_dependency "devise"

  s.add_development_dependency "rspec-rails"
end
