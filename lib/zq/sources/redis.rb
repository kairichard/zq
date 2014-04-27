module ZQ
  module Sources
    class RedisLPOP
      include NonTransactional
      def initialize(client, listname)
        @client = client
        @listname = listname
      end

      def read_next
        @client.lpop @listname
      end
    end
  end
end
