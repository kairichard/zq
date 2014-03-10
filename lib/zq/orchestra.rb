module ZQ
  @@known_orchestras = []
  @@autoregister = true

  def self.reset!
    @@known_orchestras = []
  end

  def self.register_orchestra orc
    @@known_orchestras = @@known_orchestras.push orc
  end

  def self.deregister_orchestra orc
    @@known_orchestras.reject! {|o| o == orc}
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
      def compose_with composers
        composers.each do |c|
          add_composer c
        end
      end
      def add_composer composer
        @composers ||= []
        @composers = @composers.push composer
      end
    end

    def initialize
      @source, @repository, @digester, @composers = [:@source, :@repository, :@digester, :@composers].map do |m|
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
        composite = nil
        @composers.each do |c|
          composite = c.compose item, composite
        end
      end
    end
  end
end
