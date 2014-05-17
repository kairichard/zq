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

      def transaction(&block)
        item = self.read_next
        begin
          self.commit(item) if yield(item)
        rescue
          self.rollback(item)
        end
      end
    end
  end
end

