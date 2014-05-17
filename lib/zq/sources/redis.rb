module ZQ
  module Sources

    class RedisListOP
      include NonTransactional

      class << self
        attr_accessor :client_method
      end

      def initialize(client, listname)
        @client = client
        @listname = listname
      end

      def read_next
        @client.send(self.class.client_method, *args)
      end

      def args
        @listname
      end

      def self.method(client_method)
        self.client_method = client_method
      end

    end

    class RedisLPOP < RedisListOP
      method :lpop
    end

    class RedisRPOP < RedisListOP
      method :rpop
    end

    class RedisRPOPLPUSH < RedisListOP
      include TransactionalMixin
      method :rpoplpush
      def args
        [@listname, progress_list]
      end

      def progress_list
        @listname + '_progress'
      end

      def rollback(item)
        @client.rpush(@listname, item)
      end

      def commit(item)
        @client.lrem(progress_list, 0, item)
      end

    end

    class RedisTransactionalQueue < RedisRPOPLPUSH
      method :rpoplpush
    end
  end
end
