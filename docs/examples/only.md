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
# => #<User:0x000000010c47b4b0 id: 10, email: "luke@example.com", first_name: "Luke", last_name: "Skywalker", status: "pending", two_factor_enabled: true, created_at: Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00, updated_at: Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00>

user.methods.count
# => 537

user.first_name
# => "Luke"

user.email
# => "luke@example.com"

user.status
# => "pending"

# DEFAULT BEHAVIOR
user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8 @created_at=Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00, @email="luke@example.com", @first_name="Luke", @id=10, @last_name="Skywalker", @status="pending", @two_factor_enabled=true, @updated_at=Tue, 19 Jul 2022 20:52:06.326792000 UTC +00:00>

user_dto.methods.count
# => 104

user_dto.first_name
# => "Luke"

user_dto.email
# => "luke@example.com"

user_dto.status
# => "pending"

# WHEN PASSING `only` OPTION TO `#to_dto`
user_dto2 = user.to_dto(only: [:email, :status])
# => #<UserDTO:0x000000010ec6ee40 @email="luke@example.com", @status="pending">

user_dto2.methods.count
# => 98

user_dto2.first_name
# undefined method `first_name' for #<UserDTO:0x000000010ec6ee40> (NoMethodError)
# user_dto2.first_name
#          ^^^^^^^^^^^

user_dto2.email
# => "luke@example.com"

user_dto2.status
# => "pending"
```
