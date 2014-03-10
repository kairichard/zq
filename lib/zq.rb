require 'zq/orchestra'
require 'zq/cli'

module ZQ
  module MakeSingleton
    def self.included base
      base.class_exec do
        def self.included base
          base.class_exec do
            include Singleton
          end
        end
      end
    end
  end

  module DataSource
    include MakeSingleton
    attr_accessor :contents

    def initialize
      self.contents = []
    end
    def insert data
      self.contents << data
    end
    def read_next
      self.contents.shift
    end
    def clear
      self.contents = []
    end
  end
end
