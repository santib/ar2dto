# AR2DTO ![AR2DTO](docs/images/logo.png)

AR2DTO (ActiveRecord to DTO, pronounced R2-D2 or Artoo-Detoo) is a gem that lets you create [DTOs](https://martinfowler.com/eaaCatalog/dataTransferObject.html) (data transfer objects) from your ActiveRecord models. It is a simple and small gem to encourage the usage of simpler objects across an app rather than ActiveRecord models, to help with coupling issues in large Rails apps.

![CI](https://github.com/santib/ar2dto/workflows/CI/badge.svg)

## Table of Contents

- [Motivation](#motivation)
  - [Why AR2DTO?](#why-ar2dto)
- [Installation](#installation)
- [Usage](#usage)
  - [Setting up your models](#setting-up-your-models)
  - [DTO class](#dto-class)
  - [#to_dto](#to_dto)
  - [.to_dto](#to_dto-1)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Motivation

ActiveRecord is a very powerful tool and extensively used in most Rails apps. When working on large Rails apps, having such powerful objects all over the place can have a negative impact on the maintainability of the app. This is even more clear when trying to create domain boundaries within a Rails monolith. When there is communication between different components you probably don't want to share an ActiveRecord model with other components, if you do that, you'll be giving direct access to your component's tables from anywhere. For that reason, we want to create POROs that look like ActiveRecord models but that are much simpler and only carry data. This could be done by hand, but with this gem, we are trying to help you avoid having to write all the boilerplate to create these objects. As a corollary, by using this gem you are standardizing how things are done, and how your data-only objects look like.

### Why AR2DTO?

- It lets you work with objects that are similar to ActiveRecord models but without DB access or business logic.
- It impedes ActiveRecord models leaking through its methods.
- It helps you reduce boilerplate.
- It provides a standard way to work with data-only objects.
- It is a very small gem focused on solving one specific problem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ar2dto'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ar2dto

## Usage

In the following sections, we explain the API provided by the gem and some basic usage.

### Setting up your models

To use the gem, you need to add `has_dto` to your ActiveRecord models. For example:
```ruby
class User < ApplicationRecord
  has_dto
end
```

This will dynamically create a class called `UserDTO` and will add two methods to your ActiveRecord model: [#to_dto](#to_dto) and [.to_dto](#to_dto-1).

### DTO class

This class is dynamically created based on your models that declare `has_dto`. The goal of these classes is to be data-only. They don't have access to the DB, business logic, or calculate things on the fly. They just store the data and provide them in a read-only fashion through plain simple methods.

In addition to that, and optionally, you can have these objects be compliant with the [ActiveModel API](https://github.com/rails/rails/blob/main/activemodel/lib/active_model/lint.rb), you can do that by configuring it globally with:

```ruby
# config/initializers/ar2dto.rb

AR2DTO.setup do |config|
  config.active_model_compliance = true
end
```

With this, it'll be even easier to interchange ActiveRecord models for DTOs, because other parts of Rails and other gems will continue to work (e.g. Rails route helpers).

### #to_dto

When calling `#to_dto` on an ActiveRecord model, a DTO object will be initialized with the model attributes. As an example:

```ruby
user = User.create!(name: 'John', email: 'john@example.com')
user_dto = user.to_dto
# #<UserDTO:0x00007fab8ce66a10 @name="John" @email="john@example.com">
```

`user_dto` will be an instance of `UserDTO` and, by default, it will be initialized with the same attributes as the model, that is: `id`, `name`, `email`, `created_at`, and `updated_at`.

You can then use `user_dto` across your app, and even share it with other components, without having to worry about others making queries, modifying data, or even running business logic, where they shouldn't.

### .to_dto

This method is similar to `#to_dto` but meant for `ActiveRecord::Relation`. So that running:

```ruby
User.last(10).to_dto
```

will return an `Array` consisting of 10 `UserDTO`. With this you are forcing the executing of the query, having collections of simple data objects, and avoiding other parts of the app from modifying the query.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/santib/ar2dto. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/santib/ar2dto/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AR2DTO project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/santib/ar2dto/blob/main/CODE_OF_CONDUCT.md).
