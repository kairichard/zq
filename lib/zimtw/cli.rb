require 'thor'

module Zimtw
  class CLI < Thor

    desc "work", "Start orchestrating."
    option :only, :aliases => ["-o"], :type => :string
    def work
      orchestras = Zimtw.known_orchestras.select{|o| o.to_s == options[:only]}
      orchestras.map do |o|
        Thread.new { o.new.process_until_exhausted }
      end.each(&:join)
    end
  end
end
