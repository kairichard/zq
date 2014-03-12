require 'thor'
require 'zq/orchestra'
require 'zq/exceptions'

require 'pry'

module ZQ
  class CLI < Thor
    class_option :req, :aliases => ["-r"], :type => :array, :default => []

    desc "list", "List available orchestras."
    def list
      options[:req].each do |r|
        require r
      end
      orchestras = ZQ.live_orchestras
      raise NoOrchestrasFound if orchestras.empty?
      orchestras.each do |o|
        puts o
      end
    end

    desc "work", "Start orchestrating."
    option :only,    :aliases => ["-o"], :type => :string
    option :forever, :aliases => ["-d"], :type => :boolean, :default => false
    def work
      orchestras = ZQ.live_orchestras
      raise NoOrchestrasFound if orchestras.empty?
      if options[:only]
        orchestras = orchestras.select{|o| o.to_s == options[:only]}
      end
      orchestras.map do |o|
        Thread.new do
          orchestra = o.new
          if options[:forever]
            orchestra.process_forever
          else
            orchestra.process_until_exhausted
          end
        end
      end.each(&:join)
    end
  end
end
