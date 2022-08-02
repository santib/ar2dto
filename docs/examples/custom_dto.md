## With a custom class inheriting from `AR2DTO::DTO`:
```ruby
class User < ActiveRecord::Base
  has_dto
end

class UserDTO < AR2DTO::DTO[User]
  def full_name
    "#{first_name} #{last_name}"
  end
end

user = User.create!(
  first_name: 'Luke',
  last_name: 'Skywalker',
  email: 'luke@example.com'
)

user_dto = user.to_dto
# => #<UserDTO:0x000000010d6dd2e8 @created_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, @email="luke@example.com", @first_name="Luke", @id=1, @last_name="Skywalker", @updated_at=Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00>

user_dto.full_name
# => "Luke Skywalker"
```

### Notes
- If the DTO class already exists, `AR2DTO` will use it instead of dynamically creating it.
- If you are going to use the acronym `DTO` in your own classes (in the example `UserDTO`) you need to define the acronym in Rails with:
```ruby
# config/initializers/inflections.rb
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'DTO'
end
```

## With a custom class that is a PORO:
```ruby
class User < ActiveRecord::Base
  has_dto
end

class UserDTO
  def initialize(data = {})
    @data = data
  end

  def full_name
    "#{@data["first_name"]} #{@data["last_name"]}"
  end
end

user = User.create!(
  first_name: 'Luke',
  last_name: 'Skywalker',
  email: 'luke@example.com'
)

user_dto = user.to_dto
# => #<UserDTO:0x00007fecdace3d20 @data={"created_at"=>Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00, "email"=>"luke@example.com", "first_name"=>"Luke", "id"=>1, "last_name"=>"Skywalker", "updated_at"=>Mon, 01 Aug 2022 02:23:08.698812000 UTC +00:00}>

user_dto.full_name
# => "Luke Skywalker"
```
