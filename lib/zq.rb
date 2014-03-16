require 'zq/orchestra'
require 'zq/sources/io'
require 'zq/composer/echo'
require 'zq/cli'

module ZQ
  module MakeSingleton
    def self.included(base)
      base.class_exec do
        def self.included(base)
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
      @contents = []
    end

    def insert(data)
      @contents << data
    end

    def read_next
      @contents.shift
    end

    def clear
      @contents = []
    end
  end
end
