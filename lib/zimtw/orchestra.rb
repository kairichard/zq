module Zimtw
  module Orchestra
    def self.included base
      ::Zimtw.register_orchestra base
      base.extend ClassMethods
    end

    module ClassMethods
      def source source
        @source = source
      end
      def repository repository
        @repository = repository
      end
      def digester digester
        @digester = digester
      end
    end

    def initialize
      @source, @repository, @digester = [:@source, :@repository, :@digester].map do |m|
        self.class.instance_variable_get(m)
      end
    end

    def process_forever
      loop do
        process_until_exhausted
      end
    end

    def process_until_exhausted
      loop do
        item = @source.read_next
        break if item.nil?
        @repository.create @digester.digest(item)
      end
    end
  end
end
