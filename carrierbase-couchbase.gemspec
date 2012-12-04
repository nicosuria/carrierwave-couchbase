# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "carrierwave-couchbase"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["jabberfest", "Nico Suria"]
  s.email       = ["nico.suria@payrollhero.com"]
  s.homepage    = "https://github.com/jabberfest/carrierwave-couchbase"
  s.summary     = %q{CouchBase support for CarrierWave}
  s.description = %q{CouchBase support for CarrierWave}

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_dependency "carrierwave"
  s.add_dependency "couchbase"
  s.add_dependency "couchbase-model"
end