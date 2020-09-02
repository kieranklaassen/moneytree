$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "moneytree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = 'moneytree-rails'
  spec.version       = Moneytree::VERSION
  spec.authors       = ['Kieran Klaassen']
  spec.email         = ['kieranklaassen@gmail.com']
  spec.summary       = 'A payments engine for rails centered aorund transactional payments and orders.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/kieranklaassen/moneytree'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', '>= 4.2'

  spec.add_development_dependency "sqlite3"
end
