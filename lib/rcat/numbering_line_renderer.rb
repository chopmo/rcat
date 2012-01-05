module RCat
  class NumberingLineRenderer
    def initialize(display, print_if)
      @display = display
      @print_if = print_if
      reset
    end

    def reset
      @line_num = 1
    end

    def render_line(lines)
      current_line = lines.next
      if @print_if.call(current_line)
        print_labeled_line(current_line)
      else
        print_unlabeled_line(current_line)
      end
    end

    def print_labeled_line(line)
      @display.print_labeled_line(line, @line_num)
      @line_num +=1
    end

    def print_unlabeled_line(line)
      @display.print_unlabeled_line(line)
    end
  end
end
