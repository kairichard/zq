module ZQ
  class CLI < Thor
    class_option :file, aliases: ['-r'], type: :string, desc: "Require file to load orchestras from"

    desc 'list', 'List available orchestras.'
    def list
      setup_env(options)
      orchestras = ZQ.live_orchestras
      fail NoOrchestrasFound if orchestras.empty?
      orchestras.each do |o|
        puts o
      end
    end

    desc 'play ORCHESTRA_NAME', 'Start orchestrating.'
    option :forever, aliases: ['-d'], type: :boolean, default: false, desc: "Keep running even if source is exhausted"
    option :interval, aliases: ['-i'], type: :numeric, default: 0, desc: "Play orchestra every N seconds"
    def play(orchestra_name)
      setup_env(options)
      orchestra = ZQ.find_live_orchestra(orchestra_name)
      fail OrchestraDoesNotExist unless orchestra
      run(orchestra, options[:forever], options[:interval])
    end

    private

    def setup_env(options)
      return unless options[:file]
      cwd = Pathname.pwd
      require cwd + options[:file]
    end

    def run(orchestra_cls, forever, interval)
      orchestra = orchestra_cls.new
      if forever
        orchestra.process_forever(interval)
      elsif interval
        orchestra.process_with_interval(interval)
      else
        orchestra.process_until_exhausted
      end
    end
  end
end
