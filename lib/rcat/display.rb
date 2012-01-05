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

  module ExtraLineSqueezer
    def render_line(lines)
      current_line = lines.peek
      super
      if current_line.chomp.empty?
        lines.next while lines.peek.chomp.empty?
      end
    end
  end
  
  
  class Display
    def initialize(params)
      @line_numbering_style   = params[:line_numbering_style]
      @squeeze_extra_newlines = params[:squeeze_extra_newlines]

      if @line_numbering_style == :none
        @renderer = LineRenderer.new(self)
      else
        print_all = @line_numbering_style == :all_lines
        number_pred = ->(l) { print_all || !l.chomp.empty? }
        @renderer = NumberingLineRenderer.new(self, number_pred)
      end
      
      @renderer.extend(ExtraLineSqueezer) if @squeeze_extra_newlines
    end

    def render(data)
      @renderer.reset
      lines = data.lines # needed why?
      loop { @renderer.render_line(lines) }
    end

    attr_reader :line_numbering_style, :squeeze_extra_newlines, :line_number

    def print_labeled_line(line, line_number)
      print "#{line_number.to_s.rjust(6)}\t#{line}" 
    end

    def print_unlabeled_line(line)
      print line
    end

    def increment_line_number
      @line_number += 1
    end
  end
end
