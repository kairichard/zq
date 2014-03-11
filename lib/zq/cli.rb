require 'thor'

module ZQ
  class CLI < Thor
    desc "work", "Start orchestrating."
    option :only,    :aliases => ["-o"], :type => :string
    option :forever, :aliases => ["-d"], :type => :boolean, :default => false
    def work
      orchestras = ZQ.live_orchestras
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
