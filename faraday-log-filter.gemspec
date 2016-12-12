lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "faraday/log_filter/version"

Gem::Specification.new do |spec|
  spec.name = "faraday-log-filter"
  spec.version = Faraday::LogFilter::VERSION
  spec.authors = ["Westfield Labs"]
  spec.email = [""]

  spec.summary = "A way to filter request params in logger for Faraday."
  spec.description = "A Faraday middleware for params filtering in logs."
  spec.homepage = "https://github.com/westfieldlabs/faraday-log-filter"

  spec.files = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }

  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "faraday", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rspec", "~> 3.0"
end
