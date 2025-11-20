# frozen_string_literal: true

require "bundler/setup"
require "active_record"
require "database_cleaner/active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require "ar2dto"

require "support/active_model"
require "support/schema"
require "zeitwerk"
require "#{File.dirname(__FILE__)}/support/database_cleaner_monkeypatch.rb"
loader = Zeitwerk::Loader.new
loader.inflector.inflect "person_dto" => "PersonDTO"
loader.push_dir("spec/support/fixtures")
loader.setup

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Prevent configuration of being shared through examples
  config.before :each do
    AR2DTO::Config.reset! if Object.const_defined?("AR2DTO::Config")
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
