require File.dirname(__FILE__)+'/lib/boot'
require 'logger'
Log = Logger.new(STDERR) unless defined?(Log)

require 'configliere'
require 'icss'
require 'icss/brevity'
require 'icss/view_helper'
require 'addressable/uri'

require 'tilt'
require "sinatra/base"
require 'RedCloth'
require 'haml'
require 'erubis'
Tilt.register :erb, Tilt[:erubis]

#
# Settings
#
Settings.define :dump_icss_on_load, :description => "Dump a summary of each icss to the console on successful load", :type => :boolean
Settings.define :logging,           :description => "Should Sinatra output a log line as well",                      :type => :boolean
Settings.read(ROOT_DIR.path("config/infochimps_explorer.yaml"), :env => ENV['RACK_ENV'])
Settings.resolve!

require 'main'
Dir[ROOT_DIR.path("app/**/*.rb")].each do |file| require file ; end

#
# Define routes
#
class ::Main < Sinatra::Base
  set :app_file, __FILE__

  get "/" do
    @icss = nil
    erb(:layout)
  end

  # Debug
  get %r{^/debug/?} do
    haml :debug
  end

  #
  # Load all ICSS protocols
  #
  PROTOCOLS = {}
  Dir[ROOT_DIR.path('datasets/**/*.icss.*')].sort.each do |icss_filename|
    PROTOCOLS[File.basename(icss_filename)] = Icss::Protocol.receive_from_file(icss_filename)
  end

  #
  # Create each /describe route
  #
  PROTOCOLS.each do |pnm, protocol|
    protocol.messages.each do |msg_name, message|
      get "/describe/#{message.path}" do
        @icss = protocol
        erb(:layout)
      end
    end
  end
end
Main.run! if Main.run?
