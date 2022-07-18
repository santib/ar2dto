## With configuration passed via `to_dto`
```ruby
class User < ActiveRecord::Base
  has_many :orders, class_name: "Shop::Order"
  has_one :person
  has_one :member

  enum status: { pending: 0, confirmed: 1 }

  has_dto

  def full_name
    "#{first_name} #{last_name}"
  end
end

class Person < ActiveRecord::Base
  belongs_to :user

  has_dto
end

class Member < ActiveRecord::Base
  belongs_to :user
  # does not have `has_dto`
end

module Shop
  class Order < ActiveRecord::Base
    belongs_to :user

    has_dto
  end
end

user = User.create!(
  first_name: 'Luke',
  last_name: 'Skywalker',
  email: 'luke@example.com',
  status: 'pending',
  two_factor_enabled: true
)

Person.create!(
  user: user,
  first_name: 'Luke',
  last_name: 'Skywalker'
)

Member.create!(
  user: user,
  first_name: 'Luke',
  last_name: 'Skywalker'
)

Shop::Order.create!(
  user: user,
  number: 'A-150'
  total: 100.00
)

Shop::Order.create!(
  user: user,
  number: 'A-151'
  total: 50.00
)

user_dto = user.to_dto
# => #<UserDTO:0x000000010f6c82d8>

user_dto2 = user.to_dto(include: [:orders])
# => #<UserDTO:0x000000010fc598a0>

user_dto3 = user.to_dto(include: [:orders, :person])
# => #<UserDTO:0x000000010f59ae38>

user.methods.count
# => 550

user_dto.methods.count
# => 104

user_dto2.methods.count
# => 105

user_dto3.methods.count
# => 106

# DEFAULT BEHAVIOR
user_dto.orders
# undefined method `orders' for #<UserDTO:0x000000010f6c82d8> (NoMethodError)
# user_dto.orders
#         ^^^^^^^

user_dto.person
# undefined method `person' for #<UserDTO:0x000000010f6c82d8> (NoMethodError)
# user_dto.person
#         ^^^^^^^

# WHEN PASSING `include` OPTION TO `#to_dto`
user_dto2.orders
# =>
# [#<Shop::OrderDTO:0x000000010fc5ba10>,
#  #<Shop::OrderDTO:0x000000010fc59f58>]

user_dto2.orders.first.number
# => "A-150"

user_dto2.person
# undefined method `person' for #<UserDTO:0x000000010fc598a0> (NoMethodError)
# user_dto.person
#         ^^^^^^^

user_dto3.orders
# =>
# [#<Shop::OrderDTO:0x000000010f5a11e8>,
#  #<Shop::OrderDTO:0x000000010f5a09c8>]

user_dto3.orders.first.number
# => "A-150"

user_dto3.person
# => #<PersonDTO:0x000000010f59b4a0>

user_dto3.person.first_name
# => "Luke"

# WHEN PASSING `include` OPTION TO `#to_dto` for a model without `has_dto`
user_dto4 = user.to_dto(include: [:member])
# `method_missing': undefined method `to_dto' for #<Member> (NoMethodError)
```
