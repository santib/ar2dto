## With configuration passed via `to_dto`
```ruby
class User < ActiveRecord::Base
  enum status: { pending: 0, confirmed: 1 }

  has_dto

  def full_name
    "#{first_name} #{last_name}"
  end
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
#  created_at: Tue, 19 Jul 2022 20:34:10.728490000 UTC +00:00,
#  updated_at: Tue, 19 Jul 2022 20:34:10.728490000 UTC +00:00>

user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8>

user_dto2 = user.to_dto(methods: [:full_name])
# => #<UserDTO:0x000000010ec6ee40>

user.methods.count
# => 550

user_dto.methods.count
# => 104

user_dto2.methods.count
# => 105

user.full_name
# => "Luke Skywalker"

# DEFAULT BEHAVIOR
user_dto.full_name
# undefined method `full_name' for #<UserDTO:0x000000010d6dd2e8> (NoMethodError)
# user_dto.full_name
#         ^^^^^^^^^^

# WHEN PASSING `methods` OPTION TO `#to_dto`
user_dto2.full_name
# => "Luke Skywalker"
```
