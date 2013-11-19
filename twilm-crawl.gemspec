# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twilm/crawl/version'

Gem::Specification.new do |spec|
  spec.name          = "twilm-crawl"
  spec.version       = Twilm::Crawl::VERSION
  spec.authors       = ["Fredrik Persen Fostvedt"]
  spec.email         = ["fpfostvedt@gmail.com"]
  spec.description   = %q{Twitter movie crawler using Anemone}
  spec.summary       = %q{Twitter Movie Crawler}
  spec.homepage      = "https://github.com/theminted/twilm-crawl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "mongo"
  spec.add_runtime_dependency "mongo_mapper"
  spec.add_runtime_dependency "anemone"

  spec.add_runtime_dependency "require_all"
  spec.add_runtime_dependency "ruby-debug19"
end
