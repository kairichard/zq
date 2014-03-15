require 'thor'
require 'zq/orchestra'
require 'zq/exceptions'

module ZQ
  class CLI < Thor
    class_option :req, aliases: ['-r'], type: :array, default: []

    desc 'list', 'List available orchestras.'
    def list
      options[:req].each do |r|
        require r
      end
      orchestras = ZQ.live_orchestras
      fail NoOrchestrasFound if orchestras.empty?
      orchestras.each do |o|
        puts o
      end
    end

    desc 'work ORCHESTRA_NAME', 'Start orchestrating.'
    option :forever, aliases: ['-d'], type: :boolean, default: false
    def play(orchestra_name)
      orchestra = ZQ.find_live_orchestra(orchestra_name)
      fail NoOrchestrasFound unless orchestra
      run(orchestra, options[:forever])
    end

    private

    def run(orchestra_cls, forever = false)
      orchestra = orchestra_cls.new
      if options[:forever]
        orchestra.process_forever
      else
        orchestra.process_until_exhausted
      end
    end
  end
end
