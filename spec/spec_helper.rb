# frozen_string_literal: true

require "bundler/setup"
require "active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require "ar2dto"

require "support/active_model"
require "support/schema"
require "zeitwerk"
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

  config.around(:each) do |example|
    User.delete_all
    Person.delete_all
    Car.delete_all
    Shop::LineItem.delete_all
    Shop::Order.delete_all
    Other.delete_all

    example.run
  end
end
