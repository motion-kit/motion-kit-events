unless defined?(Motion::Project::Config)
  raise "The MotionKit::Events gem must be required within a RubyMotion project Rakefile."
end


require 'motion-kit'
require 'dbt'


Motion::Project::App.setup do |app|
  lib = File.join(File.dirname(__FILE__), 'motion-kit-events')

  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end

  DBT.analyze(app)
end
