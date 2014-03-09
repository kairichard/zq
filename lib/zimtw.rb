require_relative 'zimtw/orchestra'

module Zimtw

  @@known_orchestras = []

  def self.register_orchestra orc
    @@known_orchestras = @@known_orchestras.push orc
  end

  def self.known_orchestras
    @@known_orchestras
  end

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
  end

  module Repository
    include MakeSingleton
    def initialize
      @contents = []
    end
    def all
      @contents
    end
    def create e
      @contents << e
    end
    def clear
      @contents = []
    end
  end
end
