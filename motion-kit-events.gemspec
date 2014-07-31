# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-kit-events/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'motion-kit-events'
  gem.version       = MotionKit::Events::VERSION
  gem.licenses      = ['BSD']

  gem.authors = ['Colin T.A. Gray']
  gem.email   = ['colinta@gmail.com']
  gem.summary     = %{Adds simple event methods to MotionKit::Layout classes.}
  gem.description = <<-DESC
== Description

Use +on+ and +trigger+ to send generic events from the layout to the controller.

Sounds simple, but this enables a powerful method of keeping your UI logic
contained in your Layout files.
DESC

  gem.homepage    = 'https://github.com/motion-kit/motion-kit-events'

  gem.files       = Dir.glob('lib/**/*.rb')
  gem.files      << 'README.md'
  gem.test_files  = Dir.glob('spec/**/*.rb')

  gem.require_paths = ['lib']

  gem.add_dependency 'motion-kit'
  gem.add_dependency 'dbt'
end
