
# Group the input enumerable of lines where blank lines separate
# the groups. Also removes trailing newlines (chomp).
def group_blank_separated(lines)
  arr = []
  curr = []
  lines.map(&:chomp).each do |line|
    if line.empty?
      if !curr.empty?
        arr << curr
        curr = []
      end
    else
      curr << line
    end
  end
  arr << curr unless curr.empty?
  arr
end

class IO
  def self.readlines_blank_separated(filename)
    group_blank_separated(self.readlines(filename))
  end
end

class Array
  def sum
    self.reduce(&:+)
  end
end
