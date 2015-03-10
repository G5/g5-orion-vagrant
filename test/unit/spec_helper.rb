require 'chefspec'
require 'chefspec/berkshelf'
require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'
end
