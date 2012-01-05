module RCat
  module Utils
    def blank_line?(line)
      line.chomp.empty?
    end
  end

  class LinePrinter
    def print_line(line)
      print line
    end

    def reset
      # Do nothing
    end
  end

  class ExtraNewlineSqueezer
    include Utils

    def initialize(printer)
      @printer = printer
      @prev_line_blank = false
    end

    def print_line(line)
      unless @prev_line_blank && blank_line?(line)
        @printer.print_line(line)
      end
      @prev_line_blank = blank_line?(line)
    end

    def reset
      @printer.reset
    end
  end

  class LineNumberer
    include Utils

    def initialize(printer, options = {})
      @printer = printer
      @only_significant = options[:mode] == :significant_lines
      @line_number = 1
    end

    def print_line(line)
      if blank_line?(line) && @only_significant
        @printer.print_line(line)
      else
        @printer.print_line("#{@line_number.to_s.rjust(6)}\t#{line}" )
        @line_number += 1
      end
    end

    def reset
      @printer.reset
      @line_number = 1
    end
  end
  
  class Display
    def initialize(params)
      line_numbering_style   = params[:line_numbering_style]
      squeeze_extra_newlines = params[:squeeze_extra_newlines]

      @printer = LinePrinter.new

      if line_numbering_style
        @printer = LineNumberer.new(@printer, :mode => line_numbering_style)
      end

      if squeeze_extra_newlines
        @printer = ExtraNewlineSqueezer.new(@printer)
      end
    end

    def render(data)
      @printer.reset
      data.lines.each do |line|
        @printer.print_line(line)
      end
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
