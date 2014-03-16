module ZQ
  module Sources
    class IOSource
      def initialize file
        @file = file
      end

      def read_next
        begin
          @file.readline[0..-2]
        rescue EOFError
        end
      end
    end
  end
end
