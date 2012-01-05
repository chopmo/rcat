module RCat

  class LineRenderer
    def initialize(display)
      @display = display
    end

    def reset
    end

    def render_line(lines)
      @display.print_unlabeled_line(lines.next)
    end
  end

  class NumberingLineRenderer
    def initialize(display, only_significant = false)
      @display = display
      @only_significant = only_significant
      reset
    end

    def reset
      @line_num = 1
    end

    def render_line(lines)
      current_line = lines.next 
      current_line_is_blank = current_line.chomp.empty?

      if @only_significant && current_line_is_blank
        print_unlabeled_line(current_line)
      else
        print_labeled_line(current_line)
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

      @renderer = case @line_numbering_style
                  when :all_lines
                    NumberingLineRenderer.new(self)
                  when :significant_lines
                    NumberingLineRenderer.new(self, :only_significant)
                  when :none
                    LineRenderer.new(self)
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
