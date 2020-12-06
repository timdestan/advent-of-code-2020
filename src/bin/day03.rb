#!/usr/bin/ruby

$array = []

IO.readlines("data/day03input.txt").each do |line|
  line.chomp!
  $array.push(line)
end

# puts $array

def calc(id, jd)
  i = id
  j = jd
  nt = 0
  while i < $array.size
    if $array[i][j % $array[i].size] == '#'
      nt += 1
    end
    i += id
    j += jd
  end
  nt
end

puts "part1 = #{calc(1,3)}"
puts "part2 = #{calc(1,1) * calc(1,3) * calc(1,5) * calc(1,7) * calc(2,1)}"
