module ZQ
  @@known_orchestras = []
  @@autoregister = true

  def self.register_orchestra orc
    @@known_orchestras = @@known_orchestras.push orc
  end

  def self.known_orchestras
    @@known_orchestras
  end

  def self.stop_autoregister_orchestra!
    @@autoregister = false
  end

  def self.autoregister_orchestra!
    @@autoregister = true
  end

  def self.autoregister_orchestra?
    @@autoregister
  end

  module Orchestra
    def self.included base
      ::ZQ.register_orchestra(base) if ::ZQ.autoregister_orchestra?
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
