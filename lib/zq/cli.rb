require 'thor'
require 'zq/orchestra'
require 'zq/orchestras/echo'
require 'zq/exceptions'

module ZQ
  class CLI < Thor
    class_option :file, aliases: ['-r'], type: :string

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
    option :forever, aliases: ['-d'], type: :boolean, default: false
    def play(orchestra_name)
      setup_env(options)
      orchestra = ZQ.find_live_orchestra(orchestra_name)
      fail OrchestraDoesNotExist unless orchestra
      run(orchestra, options[:forever])
    end

    private

    def setup_env(options)
      return unless options[:file]
      cwd = Pathname.pwd
      require cwd + options[:file]
    end

    def run(orchestra_cls, forever = false)
      orchestra = orchestra_cls.new
      if forever
        orchestra.process_forever
      else
        orchestra.process_until_exhausted
      end
    end
  end
end
