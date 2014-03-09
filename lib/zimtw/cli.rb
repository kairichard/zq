require 'thor'

module Zimtw
  class CLI < Thor

    desc "work", "Start orchestrating."
    def work
      Zimtw.known_orchestras.map do |o|
        Thread.new { o.new.process_until_exhausted }
      end.each(&:join)
    end
  end
end
