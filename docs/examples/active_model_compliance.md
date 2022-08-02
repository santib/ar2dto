## With default configuration:
```ruby
class User < ActiveRecord::Base
  has_dto
end

user = User.create!(
  first_name: 'Luke',
  last_name: 'Skywalker',
  email: 'luke@example.com'
)

user.methods.count
# => 550

app.user_path(user)
# => "/users/1"

user.persisted?
# => true

user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @email="luke@example.com", @first_name="Luke", @id=1, @last_name="Skywalker", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>

user_dto.methods.count
# => 104

app.user_path(user_dto)
# => "/users/1"

user_dto.persisted?
# => true
```

## With custom configuration to disable ActiveModel compliance:
```ruby
# config/initializers/ar2dto.rb
AR2DTO.configure do |config|
  config.active_model_compliance = false
end

user_dto2 = user.to_dto
# => #<UserDTO:0x00000001102acd38 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @email="luke@example.com", @first_name="Luke", @id=1, @last_name="Skywalker", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>

user_dto2.methods.count
# => 98

app.user_path(user_dto2)
# => "/users/%23%3CUserDTO:0x00000001102acd38%3E"

user_dto2.persisted?
# undefined method `persisted?' for #<UserDTO:0x00000001102acd38> (NoMethodError)
# user_dto2.persisted?
#         ^^^^^^^^^^^
```
