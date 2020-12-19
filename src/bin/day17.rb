#!/usr/bin/ruby

require_relative '../lib.rb'

$cube = {}
$cube[0] = {}
$cube[0][0] =
  IO.readlines("data/day17input.txt")
    .map(&:chomp).map.with_index do |l, i|
  [i, l.split('').map.with_index{|x,j| [j,x]}.to_h]
end.to_h

def get(x, y, z, w)
  if $cube[w].nil?
    '.'
  elsif $cube[w][z].nil?
    '.'
  elsif $cube[w][z][y].nil?
    '.'
  else
    $cube[w][z][y][x] || '.'
  end
end

def print_cube
  $cube.each do |w, cube|
    cube.each do |z, square|
      puts "z = #{z}, w = #{w}"
      square.each do |y, xs|
        puts xs.values.join('')
      end
      puts
    end
  end
end

def all_states
  $cube.map do |_,m|
    m.map do |_,m|
      m.map do |_,m|
        m.values
      end
    end
  end.flatten
end

deltas = [-1, 0, 1]
$xyzw_deltas = deltas.product(deltas).product(deltas).product(deltas)
    .map(&:flatten)
    .reject { |coords| coords.all?(&:zero?) }

def neighbors(x, y, z, w)
  arr = []
  $xyzw_deltas.each do |dx,dy,dz,dw|
    arr << [x+dx, y+dy, z+dz, w+dw]
  end
  fail(arr.inspect) unless arr.size == 80
  arr
end

def num_active(indices)
  indices.filter do |args|
    get(*args) == '#'
  end.size
end

def next_state(x, y, z, w)
  case get(x, y, z, w)
  when '#'
    n = num_active(neighbors(x, y, z, w))
    if n == 2 || n == 3
      '#'
    else
      '.'
    end
  when '.'
    if num_active(neighbors(x, y, z, w)) == 3
      '#'
    else
      '.'
    end
  else
    fail 'bad state'
  end
end

def spread(bounds)
  [bounds[0] - 1, bounds[1] + 1]
end

def range(bounds)
  (bounds[0]..bounds[1])
end

print_cube

wb = $cube.keys.minmax
zb = $cube[0].keys.minmax
yb = $cube[0][0].keys.minmax
xb = $cube[0][0][0].keys.minmax
6.times do
  xb = spread(xb)
  yb = spread(yb)
  zb = spread(zb)
  wb = spread(wb)
  ns = {}
  range(wb).each do |w|
    ns[w] = {}
    range(zb).each do |z|
      ns[w][z] = {}
      range(yb).each do |y|
        ns[w][z][y] = {}
        range(xb).each do |x|
          ns[w][z][y][x] = next_state(x, y, z, w)
        end
      end
    end
  end
  $cube = ns
  # print_cube
end

puts all_states.filter{|s| s == '#'}.size
