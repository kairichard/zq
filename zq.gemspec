$:.unshift File.expand_path("../lib", __FILE__)
require "zq/version"

Gem::Specification.new do |s|
  s.name        = 'zq'
  s.version     = ZQ::VERSION
  s.summary     = "Pull stuff from source then digest and create inside a repository"
  s.authors     = ["Kai Richard Koenig"]
  s.email       = 'kai@kairichardkoenig.de'
  s.files       = Dir.glob("lib/**/*.rb")
  s.homepage    = 'https://github.com/kairichard/zimtw'
  s.executables << 'zq'
  s.add_runtime_dependency 'thor'
  s.license = 'MIT'
  s.required_ruby_version = '>= 1.8.6'
end

