require 'thor'
require 'zq/orchestra'
require 'zq/exceptions'

module ZQ
  class CLI < Thor
    class_option :files, aliases: ['-r'], type: :array, default: []

    desc 'list', 'List available orchestras.'
    def list
      setup_env(options)
      orchestras = ZQ.live_orchestras
      fail NoOrchestrasFound if orchestras.empty?
      orchestras.each do |o|
        puts o
      end
    end

    desc 'work ORCHESTRA_NAME', 'Start orchestrating.'
    option :forever, aliases: ['-d'], type: :boolean, default: false
    def play(orchestra_name)
      setup_env(options)
      orchestra = ZQ.find_live_orchestra(orchestra_name)
      fail OrchestraDoesNotExist unless orchestra
      run(orchestra, options[:forever])
    end

    private

    def setup_env(options)
      cwd = Pathname.pwd
      options[:files].each do |r|
        require cwd + r
      end
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
