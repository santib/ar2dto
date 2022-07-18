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
```

## With custom configuration to delete suffix:
```ruby
class PersonRecord < ActiveRecord::Base
  has_dto
end

# config/initializers/ar2dto.rb
AR2DTO.configure do |config|
  config.delete_suffix = "Record"
end

person = PersonRecord.create!(
  first_name: 'John',
  last_name: 'Doe'
)

person_dto = person.to_dto
# => #<PersonDTO:0x000000011501c528>
```


## With custom configuration to delete suffix and not to add suffix:
```ruby
class PersonRecord < ActiveRecord::Base
  has_dto
end

# config/initializers/ar2dto.rb
AR2DTO.configure do |config|
  config.delete_suffix = "Record"
  config.add_suffix = nil
end

person = PersonRecord.create!(
  first_name: 'John',
  last_name: 'Doe'
)

person_dto = person.to_dto
# => #<Person:0x000000011501c528>
```
