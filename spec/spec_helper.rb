ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Require the blueprints & shams necessary to create fake records with
# Machinist.
require File.expand_path('../blueprints', __FILE__)

RSpec.configure do |config|
  # We like plain old RSpec for mocking.
  config.mock_with :rspec

  # We turn off transactional fixtures and use DatabaseCleaner
  # instead.  This lets external processes (e.g. - programmatically
  # driven web browsers) interact with data in the test databases
  # during each spec.
  config.use_transactional_fixtures = false

  # We want to make sure to get rid of all records in MySQL &
  # Elasticsearch before tests start.
  config.before(:suite) do
    DatabaseCleaner.clean
  end

  # Start DatabaseCleaner up before each test -- unless we're
  # expecting to persist records across tests.
  config.before(:each) do
    DatabaseCleaner.start unless persist_records?
  end

  # Ask DatabaseCleaner to clean up all records -- unless we're
  # expecting to persist records across tests.
  config.after(:each) do
    unless persist_records?
      DatabaseCleaner.clean
    end
  end

  config.include ControllerSpecHelper
  
  DatabaseCleaner.strategy   = :truncation
  Capybara.javascript_driver = :webkit

end
