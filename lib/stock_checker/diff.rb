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
  end
end