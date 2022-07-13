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
#         ActiveRecord     3.080k i/100ms
#                 PORO     3.530k i/100ms
#          AR2DTO::DTO     2.609k i/100ms
# Calculating -------------------------------------
#         ActiveRecord     21.663k (±36.7%) i/s -     92.400k in   5.053719s
#                 PORO    147.507k (± 7.7%) i/s -    734.240k in   5.009485s
#          AR2DTO::DTO     77.631k (±37.6%) i/s -    268.727k in   5.004677s
#
# Comparison:
#                 PORO:   147506.6 i/s
#          AR2DTO::DTO:    77631.2 i/s - 1.90x  (± 0.00) slower
#         ActiveRecord:    21662.9 i/s - 6.81x  (± 0.00) slower
