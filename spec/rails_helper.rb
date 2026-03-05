require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec/fixtures')

  # KEY FIX: false for system tests so Selenium can see the database
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :system) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
      options.add_argument('no-sandbox')
    end
  end

  config.after(:each, type: :system) do
    Capybara.reset_sessions!
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  # For non-system tests, keep using fast transaction rollback
  config.before(:each) do |example|
    unless example.metadata[:type] == :system
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do |example|
    unless example.metadata[:type] == :system
      DatabaseCleaner.clean
    end
  end
end