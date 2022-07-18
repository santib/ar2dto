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

user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8>

user.methods.count
# => 550

user_dto.methods.count
# => 104

app.user_path(user)
# => "/users/1"

user.persisted?
# => true

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
# => #<UserDTO:0x00000001102acd38>

user_dto2.methods.count
# => 98

app.user_path(user_dto2)
# => "/users/%23%3CUserDTO:0x00000001102acd38%3E"

user_dto2.persisted?
# undefined method `persisted?' for #<UserDTO:0x00000001102acd38> (NoMethodError)
# user_dto2.persisted?
#         ^^^^^^^^^^^
```
