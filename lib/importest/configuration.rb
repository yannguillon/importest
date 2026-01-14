# frozen_string_literal: true

module Importest
  class Configuration
    attr_accessor :runtime

    def initialize
      @runtime = :deno
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
