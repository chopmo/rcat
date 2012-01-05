module RCat
  module ExtraLineSqueezer
    def render_line(lines)
      current_line = lines.peek
      super
      if current_line.chomp.empty?
        lines.next while lines.peek.chomp.empty?
      end
    end
  end
end
