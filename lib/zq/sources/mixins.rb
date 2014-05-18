module ZQ
  module Sources
    module NonTransactional
      def transactional?
        false
      end
    end
    module TransactionalMixin
      def transactional?
        true
      end

      def handle_error(error, item)
      end

      def transaction(&block)
        item = self.read_next
        begin
          self.commit(item) if yield(item)
        rescue => error
          self.rollback(item)
          self.handle_error(item, error)
          throw :exhausted # or raise ?
        end
      end
    end
  end
end

