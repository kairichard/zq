module ZQ
  module Composer

    class UUID4Json
      def initialize(key = nil)
        @key = key || 'uuid'
      end
      def compose(raw_data, composite = nil)
        composite ||= raw_data
        if composite.kind_of? Hash
          composite[@key] = SecureRandom.uuid
        end
        return composite
      end
    end
  end
end
