gem 'rspec', '~> 2.4.0'
require 'rspec'

require 'ffi/hunspell'

include FFI

RSpec.configure do |specs|
  specs.before(:suite) do
    if ENV['HUNSPELL_ROOT']
      Hunspell.directories << ENV['HUNSPELL_ROOT']
    end
  end
end
