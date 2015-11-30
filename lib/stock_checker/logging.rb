require 'logger'

module StockChecker
  module Logging
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
 end