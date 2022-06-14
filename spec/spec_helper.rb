# frozen_string_literal: true

require "bundler/setup"
require "active_record"
require "database_cleaner/active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require "ar2dto"

require "support/schema"
require "support/fixtures/person"
require "support/fixtures/person_dto"
require "support/fixtures/user"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
