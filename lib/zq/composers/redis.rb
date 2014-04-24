module ZQ
  module Composer
    class RedisPublish
      def initialize(channel_name, client)
        @channel_name = channel_name
        @client = client
      end
      def compose(raw_data, composite = nil)
        composite ||= raw_data
        @client.publish(@channel_name, composite)
        return composite
      end
    end
  end
end
