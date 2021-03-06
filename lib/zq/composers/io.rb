module ZQ
  module Composer

    class NoOp
      def compose(raw_data, composite = nil)
        raw_data
      end
    end

    class Echo
      def initialize(ioo = nil)
        @file = ioo || $stdout
      end
      def compose(raw_data, composite = nil)
        composite ||= raw_data
        @file.puts composite
        composite
      end
    end
    class Tee < Echo
    end
  end
end
