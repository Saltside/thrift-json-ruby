# thrift-ut8\_json

This gem contains patches for working with [thrift][] struts & JSON
serialization/deserialization. Most importantly it contains a fix for
encoding handling when using generated thrift JSON blobs inside other
objects (e.g. persisting in a data store). This bug is documented in
the [acceptance test][].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thrift-utf8_json'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install thrift-utf8_json

## Usage

`thrift-utf8_json` adds two classes to the `Thrift` module:
`Thrift::JsonDerserializer` & `Thrift::JsonSerializer`. They mimic the
interface of `Thirft::Deserializer` & `Thrift::Serializer` except they
require no arguments to `initialize`. Here's an example:

```ruby
require 'thrift-utf8_json'

struct = SomeThriftStruct.new

json = Thrift::JsonSerializer.new.serialize(struct)
deserialized = Thrift::JsonDeserializer.new.deserialize(SomeThriftStruct.new, json)
```

## Testing

	$ make test

## Contributing

1. Fork it ( https://github.com/saltside/thrift-utf8_json-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[thrift]: https://thrift.apache.org
[acceptance test]: test/acceptance_test.rb
