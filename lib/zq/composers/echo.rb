module ZQ
  module Composer

    class NoOp
      def compose(data, composite = nil)
        data
      end
    end

    class Echo
      def initialize(ioo = nil)
        @file = ioo || $stdout
      end
      def compose(data, composite = nil)
        composite ||= data
        @file.puts composite
        return composite
      end
    end
  end
end
