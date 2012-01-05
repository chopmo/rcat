require_relative 'line_renderer'
require_relative 'numbering_line_renderer'
require_relative 'extra_line_squeezer'

module RCat
  class Display
    def initialize(params)
      @line_numbering_style   = params[:line_numbering_style]
      @squeeze_extra_newlines = params[:squeeze_extra_newlines]

      if @line_numbering_style == :none
        @renderer = LineRenderer.new(self)
      else
        print_if = ->(l) { (@line_numbering_style == :all_lines) || !l.chomp.empty? }
        @renderer = NumberingLineRenderer.new(self, print_if)
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
  end
end
