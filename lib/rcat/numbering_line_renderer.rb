module RCat
  class NumberingLineRenderer
    def initialize(display, number_pred)
      @display = display
      @number_pred = number_pred
      reset
    end

    def reset
      @line_num = 1
    end

    def render_line(lines)
      current_line = lines.next
      if @number_pred.call(current_line)
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
