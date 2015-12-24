require 'diffy'

module StockChecker
  module Diff
    # Returns formatted HTML with diff
    def self.diff(old, new)
      css = Diffy::CSS
      diff = Diffy::Diff.new(old, new).to_s(:html)

      output = String.new
      output << "<style>#{css}</style>"
      output << diff

      output
    end

    def self.is_equal?(old, new)
      return Diffy::Diff.new(old, new).to_s.empty?
    end

    def self.is_different?(old, new)
      return (! self.is_equal?(old, new))
    end
  end
end