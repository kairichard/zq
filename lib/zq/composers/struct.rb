module ZQ
  module Composer
    class JsonParse
      def compose(raw_data, composite = nil)
        composite ||= raw_data
        JSON.parse(composite)
      end
    end
  end
end

