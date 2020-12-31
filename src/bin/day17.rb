#!/usr/bin/ruby

require_relative '../lib.rb'

$cube = {}
$cube[0] = {}
$cube[0][0] =
  IO.readlines("data/day17input.txt")
    .map(&:chomp).map.with_index do |l, i|
  [i, l.split('').map.with_index{|x,j| [j,x == '#']}.to_h]
end.to_h

def get(x, y, z, w)
  cw = $cube[w]
  return false if cw.nil?
  cwz = cw[z]
  return false if cwz.nil?
  cwzy = cwz[y]
  return false if cwzy.nil?
  cwzy[x]
end

def print_cube
  $cube.each do |w, cube|
    cube.each do |z, square|
      puts "z = #{z}, w = #{w}"
      square.each do |y, xs|
        puts xs.values.map{|x| x ? '#' : '.'}.join('')
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

DELTAS = [-1, 0, 1]

def num_active_neighbors(x, y, z, w)
  n = 0
  for dw in DELTAS do
    cw = $cube[w+dw]
    next if cw.nil?
    for dz in DELTAS do
      cwz = cw[z+dz]
      next if cwz.nil?
      for dy in DELTAS do
        cwzy = cwz[y+dy]
        next if cwzy.nil?
        for dx in DELTAS do
          next if dx == 0 && dy == 0 && dz == 0 && dw == 0
          n += 1 if cwzy[x+dx]
        end
      end
    end
  end
  n
end

def next_state(x, y, z, w)
  n = num_active_neighbors(x, y, z, w)
  if n < 2 || n > 3
    false
  elsif get(x, y, z, w)
    n == 2 || n == 3
  else
    n == 3
  end
end

def spread(range)
  (range.begin - 1 .. range.end + 1)
end

def keys_to_range(hash)
  min, max = hash.keys.minmax
  (min..max)
end

print_cube

wb = keys_to_range($cube)
zb = keys_to_range($cube[0])
yb = keys_to_range($cube[0][0])
xb = keys_to_range($cube[0][0][0])
6.times do
  xb = spread(xb)
  yb = spread(yb)
  zb = spread(zb)
  wb = spread(wb)
  ns = {}
  for w in wb
    nsw = ns[w] = {}
    for z in zb do
      nswz = nsw[z] = {}
      for y in yb do
        nswzy = nswz[y] = {}
        for x in xb do
          nswzy[x] = next_state(x, y, z, w)
        end
      end
    end
  end
  $cube = ns
end

puts all_states.filter{|s| s}.size
