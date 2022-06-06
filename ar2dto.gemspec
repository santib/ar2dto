# frozen_string_literal: true

require_relative "lib/ar2dto/version"

Gem::Specification.new do |spec|
  spec.name = "ar2dto"
  spec.version = AR2DTO::VERSION
  spec.authors = ["Santiago Bartesaghi"]
  spec.email = ["santib@hey.com"]

  spec.summary = "Easing the creation of DTOs from your ActiveRecord models."
  spec.homepage = "https://github.com/santib/ar2dto"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/santib/ar2dto"
  spec.metadata["bug_tracker_uri"] = "https://github.com/santib/ar2dto/issues"
  spec.metadata["changelog_uri"] = "https://github.com/santib/ar2dto/releases"

  spec.files = Dir["LICENSE.txt", "README.md", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.2"
end
