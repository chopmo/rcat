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
  end

  class LineNumberer
    include Utils

    def initialize(printer, options = {})
      @printer = printer
      @mode = options[:mode]
      @line_number = 1
    end

    def only_significant?
      @mode == :significant_lines
    end

    def print_line(line)
      if blank_line?(line) && only_significant?
        @printer.print_line(line)
      else
        @printer.print_line("#{@line_number.to_s.rjust(6)}\t#{line}" )
        @line_number += 1
      end
    end
  end
  
  class Display
    def initialize(params)
      @line_numbering_style   = params[:line_numbering_style]
      @squeeze_extra_newlines = params[:squeeze_extra_newlines]
    end

    def create_printer
      printer = LinePrinter.new
      printer = LineNumberer.new(printer, :mode => @line_numbering_style) if @line_numbering_style
      printer = ExtraNewlineSqueezer.new(printer) if @squeeze_extra_newlines
      printer
    end

    def render(data)
      printer = create_printer
      data.lines.each do |line|
        printer.print_line(line)
      end
    end
  end
end
