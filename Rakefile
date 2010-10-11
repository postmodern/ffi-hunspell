require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:development, :doc)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = 'ffi-hunspell'
  gem.licenses = ['MIT']
  gem.summary = %Q{FFI bindings for Hunspell}
  gem.description = %Q{Ruby FFI bindings for Hunspell spell checker.}
  gem.email = 'postmodern.mod3@gmail.com'
  gem.homepage = %Q{http://github.com/postmodern/ffi-hunspell}
  gem.authors = ['Postmodern']
  gem.requirements = ['libhunspell >= 1.2.0']
  gem.has_rdoc = 'yard'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
