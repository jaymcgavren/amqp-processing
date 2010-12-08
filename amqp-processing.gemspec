# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amqp-processing/version"

Gem::Specification.new do |s|
  s.name        = "amqp-processing"
  s.version     = AMQPProcessing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jay McGavren"]
  s.email       = ["jay@mcgavren.com"]
  s.homepage    = "http://github.com/jaymcgavren/amqp-processing"
  s.summary     = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}
  s.description = %q{A server that allows multiple users to view and program a shared Ruby-Processing sketch.}
  s.extra_rdoc_files = ["README.textile", "LICENSE"]

  s.rubyforge_project = "amqp-processing"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'fuubar'
  s.add_dependency 'amqp'
  
end
