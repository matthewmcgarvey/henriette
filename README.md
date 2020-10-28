# henriette

Avram generates the Operation and the Query classes from macros ran in Model. This means that we don't have the ability to reference other models to handle certain association logic. It also creates magic code.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     henriette:
       github: matthewmcgarvey/henriette
   ```

2. Run `shards install`

## Usage (WIP)

```crystal
require "henriette"
```

### Models

```crystal
class User < Henriette::Model
  primary_key id : Int64
  column created_at : Time
  column updated_at : Time
  column name : String
  has_many credentials : Array(Credential)
end
```

### Queries

```crystal
class UserQuery < Henriette::Query(User)
  connect_to User
end
```

### Operations

```crystal
class SaveUser < Henriette::Operation
  connect_to User
end
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/matthewmcgarvey/henriette/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Matthew McGarvey](https://github.com/matthewmcgarvey) - creator and maintainer
