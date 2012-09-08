require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'fileutils'
desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
end

# Run the rdoc task to generate rdocs for this gem
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  require "multi_config/version"
  version = MultiConfig::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "multi_config #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

if RUBY_VERSION =~ /^1\.8/
    RSpec::Core::RakeTask.new(:rcov) do |spec|
      spec.pattern = 'spec/**/*_spec.rb'
      spec.rcov = true
      spec.rcov_opts = %w{--exclude pkg\/,spec\/,features\/}
    end
  else
    desc "Code coverage detail"
    task :simplecov do
      ENV['COVERAGE'] = "true"
      Rake::Task['spec'].execute
    end
end


desc  "Run all specs with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude pkg\/,spec\/,features\/}
end