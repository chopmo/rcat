module RCat
  class LineRenderer
    def initialize(display)
      @display = display
    end

    def reset
      # Nothing to do
    end

    def render_line(lines)
      @display.print_unlabeled_line(lines.next)
    end
  end
end
