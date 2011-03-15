$:.push File.expand_path('../lib', __FILE__)
require 'capistrano-basecamp/version'

Gem::Specification.new do |s|
  s.name        = 'capistrano-basecamp'
  s.version     = Capistrano::Basecamp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Priit Haamer']
  s.email       = ['priit@fraktal.ee']
  s.homepage    = 'http://rubygems.org/gems/capistrano-basecamp'
  s.summary     = %q{Posts change logs to Basecamp after Capistrano deploy.}
  s.description = %q{Capistrano plugin that posts change logs to Basecamp after deploy.}

  s.rubyforge_project = 'capistrano-basecamp'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  s.add_dependency(%q<xml-simple>)
  s.add_dependency(%q<basecamp>, ["= 0.0.2"])
end
