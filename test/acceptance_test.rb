require_relative 'test_helper'

class AcceptanceTest < MiniTest::Unit::TestCase
  def test_round_trips_itself_with_proper_encodings
    struct = SimpleStruct.new message: utf8_string
    assert_utf8 struct.message

    json = Thrift::JsonSerializer.new.serialize(struct)
    assert_utf8 json

    deserialized = Thrift::JsonDeserializer.new.deserialize(SimpleStruct.new, json)
    assert_equal struct.message, deserialized.message
    assert_utf8 struct.message
  end

  def test_bug_exists
    struct = SimpleStruct.new message: utf8_string
    assert_utf8 struct.message

    serializer = Thrift::Serializer.new Thrift::JsonProtocolFactory.new
    json = serializer.serialize struct

    # Thrift uses a binary encoding when generating the serialized string.
    # Then resulting generated string is then in a different encoding.
    assert_equal Encoding::ASCII_8BIT, json.encoding

    # This causes problems for other things that require correct encodings.
    # e.g. JSON.dump. The previously generated string contains bytes that
    # are not represented in ASCII 8 bit.
    assert_raises Encoding::UndefinedConversionError do
      JSON.dump([json])
    end
  end

  def test_bug_fix
    struct = SimpleStruct.new message: utf8_string
    assert_utf8 struct.message

    serializer = Thrift::Serializer.new Thrift::JsonProtocolFactory.new
    json = serializer.serialize struct

    # This fixes the problem mentioned in the previous test. Previously
    # unrecognized bytes will be propertly handled in UTF8
    utf8_json = json.force_encoding('UTF-8')

    # The correctly encoded JSON string should now work with encoding
    # specific code
    dumped = JSON.dump([ utf8_json ])

    # Take the thrift JSON blob and load it. This blog should deserialize
    # into the original thrift object with correct string encodings.
    # The UTF8 protocol factory will read strings in json back in the correct
    # encoding as well.
    serialized = JSON.load(dumped).first
    deserializer = Thrift::Deserializer.new Thrift::Utf8JsonProtocolFactory.new
    deserialized = deserializer.deserialize(SimpleStruct.new, serialized)

    assert_equal struct.message, deserialized.message
    assert_utf8 deserialized.message
  end

  private

  def assert_utf8(string)
    assert_equal Encoding::UTF_8, string.encoding, 'Non UTF-8 string'
  end

  def utf8_string
    "Hi, I'am a ☃ !!"
  end
end
