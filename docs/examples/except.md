## With configuration passed via `to_dto`
```ruby
class User < ActiveRecord::Base
  enum status: { pending: 0, confirmed: 1 }

  has_dto
end

user = User.create!(
  first_name: 'Luke',
  last_name: 'Skywalker',
  email: 'luke@example.com',
  status: 'pending',
  two_factor_enabled: true
)
# =>
# #<User:0x000000010c47b4b0
#  id: 10,
#  email: "luke@example.com",
#  first_name: "Luke",
#  last_name: "Skywalker",
#  status: "pending",
#  two_factor_enabled: true,
#  created_at: Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00,
#  updated_at: Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00>

user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8>

user_dto2 = user.to_dto(except: [:updated_at, :two_factor_enabled])
# => #<UserDTO:0x000000011501c528>

user.methods.count
# => 549

user_dto.methods.count
# => 104

user_dto2.methods.count
# => 102

user.created_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user.updated_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user.two_factor_enabled
# => true

# DEFAULT BEHAVIOR
user_dto.created_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user_dto.updated_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user_dto.two_factor_enabled
# => true

# WHEN PASSING `except` OPTION TO `#to_dto`
user_dto2.created_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user_dto2.updated_at
# undefined method `updated_at' for #<UserDTO:0x000000011501c528> (NoMethodError)
# user_dto2.updated_at
#          ^^^^^^^^^^^

user_dto2.two_factor_enabled
# undefined method `two_factor_enabled' for #<UserDTO:0x000000011501c528> (NoMethodError)
# user_dto2.two_factor_enabled
#          ^^^^^^^^^^^^^^^^^^^
```

## With global configuration:
```ruby
# config/initializers/ar2dto.rb
AR2DTO.configure do |config|
  config.except = [:updated_at, :two_factor_enabled]
end

user_dto3 = user.to_dto
# => #<UserDTO:0x00000001102acd38>

user_dto3.methods.count
# => 102

user_dto3.created_at
# => Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00

user_dto3.updated_at
# undefined method `updated_at' for #<UserDTO:0x00000001102acd38> (NoMethodError)
# user_dto3.updated_at
#          ^^^^^^^^^^^

user_dto3.two_factor_enabled
# undefined method `two_factor_enabled' for #<UserDTO:0x00000001102acd38> (NoMethodError)
# user_dto3.two_factor_enabled
#          ^^^^^^^^^^^^^^^^^^^
```
