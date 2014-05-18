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

    class RedisRPOPLPUSH < RedisListOP
      include TransactionalMixin
      method :rpoplpush

      def initialize(client, listname, progress_listname=nil)
        @client = client
        @listname = listname
        @progress_listname = progress_listname
      end

      def args
        [@listname, progress_listname]
      end

      def progress_listname
        @progress_listname || @listname + '_progress'
      end

      def rollback(item)
        @client.rpush(@listname, item)
      end

      def commit(item)
        @client.lrem(progress_listname, 0, item)
      end
    end

    class RedisTransactionalQueue < RedisRPOPLPUSH
      method :rpoplpush
    end

    class RedisLPOP < RedisListOP
      method :lpop
    end

    class RedisRPOP < RedisListOP
      method :rpop
    end

  end
end
