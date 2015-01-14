require 'thrift/utf8_json/version'
require 'thrift'

module Thrift
  class Utf8JsonProtocol < ::Thrift::JsonProtocol
    def read_string
      super.force_encoding('UTF-8')
    end
  end

  class Utf8JsonProtocolFactory
    def get_protocol(trans)
      return Utf8JsonProtocol.new(trans)
    end
  end

  class JsonSerializer < Serializer
    def initialize
      super Utf8JsonProtocolFactory.new
    end

    def serialize(base)
      super.force_encoding('UTF-8')
    end
  end

  class JsonDeserializer < Deserializer
    def initialize
      super Utf8JsonProtocolFactory.new
    end
  end
end
