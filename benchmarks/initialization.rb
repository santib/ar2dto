# frozen_string_literal: true

require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails"
  gem "benchmark-ips"
  gem "ar2dto", path: "../"
  gem "sqlite3"
  gem "byebug"
end

require "active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

require_relative "../spec/support/schema"
require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.inflector.inflect "person_dto" => "PersonDTO"
loader.push_dir("spec/support/fixtures")
loader.setup

attributes = {
  first_name: "Sandy",
  last_name: "Doe",
  email: "sandy@example.com",
  birthday: Time.new(1995, 8, 25),
  status: "pending"
}
user_methods = %i[full_name strange_name superman? myself]
user = User.new(attributes)
attributes_with_methods = attributes.merge(user_methods.to_h { |method| [method, user.send(method.to_s)] })

class UserPORO
  attr_accessor(*(User.attribute_names + %i[full_name strange_name myself]))

  def initialize(data = {})
    data.each { |key, value| send("#{key}=", value) if respond_to?("#{key}=") }
  end

  def superman?
    true
  end
end

Benchmark.ips do |x|
  x.report("ActiveRecord") do
    User.new(attributes)
  end

  x.report("PORO") do
    UserPORO.new(attributes_with_methods)
  end

  x.report("AR2DTO::DTO") do
    UserDTO.new(attributes_with_methods)
  end

  x.compare!
end

# Warming up --------------------------------------
#         ActiveRecord     3.356k i/100ms
#                 PORO    15.013k i/100ms
#          AR2DTO::DTO     5.023k i/100ms
# Calculating -------------------------------------
#         ActiveRecord     32.289k (± 7.0%) i/s -    161.088k in   5.016247s
#                 PORO    150.607k (± 3.3%) i/s -    765.663k in   5.089160s
#          AR2DTO::DTO     50.441k (±26.1%) i/s -    226.035k in   5.048860s
#
# Comparison:
#                 PORO:   150607.3 i/s
#          AR2DTO::DTO:    50440.8 i/s - 2.99x  (± 0.00) slower
#         ActiveRecord:    32288.9 i/s - 4.66x  (± 0.00) slower
