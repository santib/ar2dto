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
# => #<UserDTO:0x000000010d6dd2e8 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @email="luke@example.com", @first_name="Luke", @id=1, @last_name="Skywalker", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>
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
# => #<PersonDTO:0x000000011501c528 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @first_name="John", @id=1, @last_name="Doe", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>
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
  first_name: 'Mary',
  last_name: 'Smith'
)

person_dto2 = person.to_dto
# => #<Person:0x00000001102acd38 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @first_name="Mary", @id=2, @last_name="Smith", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>
```
