require 'machinist/active_record'
require File.expand_path('../shams', __FILE__)
Dir[File.expand_path("../blueprints/**/*.rb", __FILE__)].each do |blueprint_file|
  require blueprint_file.gsub(/\.rb$/,'')
end
