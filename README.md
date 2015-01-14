# thrift-json

This gem contains patches for working with [thrift][] struts & JSON
serialization/deserialization. Most importantly it contains a fix for
encoding handling when using generated thrift JSON blobs inside other
objects (e.g. persisting in a data store). This bug is documented in
the [acceptance test][].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thrift-json'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install thrift-json

## Usage

`thrift-json` adds two classes to the `thrift` module:
`Thrift::JsonDerserializer` & `Thrift::JsonSerializer`. They mimic the
interface of `Thirft::Deserializer` & `Thrift::Serializer` except they
require no arguments to `initialize`. Here's an example:

```ruby
require 'thrift-json'

struct = SomeThriftStruct.new

json = Thrift::JsonSerializer.new.serialize(struct)
deserialized = Thrift::JsonDeserializer.new.deserialize(SomeThriftStruct.new, json)
```

## Testing

	$ make test

## Contributing

1. Fork it ( https://github.com/saltside/thrift-json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[thrift]: https://thrift.apache.org
[acceptance test]: test/acceptance_test.rb
