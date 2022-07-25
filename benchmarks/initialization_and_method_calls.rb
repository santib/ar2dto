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
  user = nil

  x.report("ActiveRecord") do
    user = User.new(attributes)
    user.first_name
    user.last_name
    user.email
    user.birthday
    user.status
    user.full_name
    user.strange_name
    user.superman?
    user.myself
  end

  x.report("PORO") do
    user_poro = UserPORO.new(attributes.merge(user_methods.to_h { |method| [method, user.send(method.to_s)] }))
    user_poro.first_name
    user_poro.last_name
    user_poro.email
    user_poro.birthday
    user_poro.status
    user_poro.full_name
    user_poro.strange_name
    user_poro.superman?
    user_poro.myself
  end

  x.report("AR2DTO::DTO") do
    user_dto = user.to_dto(methods: user_methods)
    user_dto.first_name
    user_dto.last_name
    user_dto.email
    user_dto.birthday
    user_dto.status
    user_dto.full_name
    user_dto.strange_name
    user_dto.superman?
    user_dto.myself
  end

  x.compare!
end

# Warming up --------------------------------------
#         ActiveRecord     2.597k i/100ms
#                 PORO     8.361k i/100ms
#          AR2DTO::DTO     1.381k i/100ms
# Calculating -------------------------------------
#         ActiveRecord     25.462k (± 5.5%) i/s -    127.253k in   5.014754s
#                 PORO     72.650k (±20.1%) i/s -    351.162k in   5.097348s
#          AR2DTO::DTO     11.194k (±14.4%) i/s -     55.240k in   5.085644s
#
# Comparison:
#                 PORO:    72649.9 i/s
#         ActiveRecord:    25461.8 i/s - 2.85x  (± 0.00) slower
#          AR2DTO::DTO:    11193.8 i/s - 6.49x  (± 0.00) slower
