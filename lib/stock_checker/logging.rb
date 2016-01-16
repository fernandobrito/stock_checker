require 'logger'

module StockChecker

  # Logging module. Can be included as a mixin in classes
  module Logging
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
 end