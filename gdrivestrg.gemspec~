$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gdrivestrg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gdrivestrg"
  s.version     = Gdrivestrg::VERSION
  s.authors     = ["Raul Roman-Lopez"]
  s.email       = ["rroman@libresoft.es"]
  s.homepage    = "http://git.libresoft.es/gdrivestrg/"
  s.summary     = "Ruby plugin that installs a Google Drive driver"
  s.description = "Ruby plugin that installs the Google Drive driver for Cloudstrg system"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "cloudstrg", "~> 0.0.10"
  s.add_dependency "google-api-client", "~> 0.4.4"

  s.add_development_dependency "sqlite3"
end
