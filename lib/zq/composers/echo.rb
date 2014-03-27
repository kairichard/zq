module ZQ
  module Composer
    class NoOp
      def compose data, composite = nil
        data
      end
    end
    class Echo
      def compose data, composite = nil
        puts data
      end
    end
  end
end
