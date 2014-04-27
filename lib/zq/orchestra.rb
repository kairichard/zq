module ZQ
  @@live_orchestras = []
  @@_all_known_orchestras = []
  @@autoregister = true

  def self.create_orchestra(&block)
    klass = Class.new
    klass.class_exec do
      include ZQ::Orchestra
    end
    klass.class_exec(&block) if block_given?
    klass
  end

  def self.autoregister_orchestra(orc)
    register_orchestra(orc) if autoregister_orchestra?
    @@_all_known_orchestras = @@_all_known_orchestras.push(orc)
  end

  def self.register_orchestra(orc)
    @@live_orchestras = @@live_orchestras.push orc
  end

  def self.deregister_orchestra(orc)
    @@live_orchestras.reject! { |o| o == orc }
  end

  def self.live_orchestras
    @@live_orchestras
  end

  def self.find_live_orchestra(orc_name)
    live_orchestras.detect { |o| o.name == orc_name  }
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
    def self.included(base)
      ::ZQ.autoregister_orchestra(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def desc(desc)
        @desc = desc
      end

      def ignore_errors!
        @ignore_errors = true
      end

      def ignore_errors?
        @ignore_errors rescue false
      end

      def source(source)
        @source = source
      end

      def compose_with(*composers)
        composers.each do |c|
          add_composer c
        end
      end

      def add_composer(composer)
        @composers ||= []
        @composers = @composers.push composer
      end

      def to_s
        super + ' - ' + @desc
      end
    end

    def initialize
      @source, @composers = [:@source, :@composers].map do |m|
        self.class.instance_variable_get(m)
      end
      fail NoSourceProvided unless @source
      fail NoComposerProvided unless @composers
    end

    def process_forever(interval = 1)
      loop do
        process_with_interval(interval)
      end
    end

    def process_with_interval(interval)
        process_until_exhausted
        Kernel.sleep(interval)
    end

    def compose(item)
        composite = nil
        begin
          @composers.each do |c|
            composite = c.compose item, composite
          end
        rescue
          raise unless self.class.ignore_errors?
        end
    end

    def process_until_exhausted
      this = self
      catch :exhausted do
        loop do
          if @source.transactional?
            @source.transaction do |item|
              throw :exhausted if item.nil?
              this.compose(item)
            end
          else
            item = @source.read_next
            throw :exhausted if item.nil?
            compose(item)
          end
        end
      end
    end
  end
end
