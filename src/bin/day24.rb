#!/usr/bin/ruby

require_relative '../lib.rb'

paths = []
IO.readlines("data/day24input.txt").each do |line|
  paths << line.scan(/(e|se|sw|w|nw|ne)/).map { |x| x[0].to_sym }
end

DELTAS = {
  :e => [1, 0],
  :se => [0, -1],
  :sw => [-1, -1],
  :w => [-1, 0],
  :nw => [0, 1],
  :ne => [1, 1]
}
DELTA_VALS = DELTAS.values

state = Hash.new(false)
paths.each do |path|
  x = 0
  y = 0
  path.each do |p|
    dx, dy = DELTAS[p]
    x += dx
    y += dy
  end
  state[[x, y]] = !state[[x, y]]
end

puts "Num flipped: #{state.values.filter{|x| x }.size}"

def neighbors(x, y)
  DELTA_VALS.each do |dx, dy|
    yield [x + dx, y + dy]
  end
end

100.times do
  black_tiles_to_flip = []
  adjacent_white_tiles = []
  state.each do |k, v|
    next unless v
    x, y = k
    num_black_neighbors = 0
    neighbors(x, y) do |tile|
      if state[tile]
        num_black_neighbors += 1
      else
        adjacent_white_tiles << tile
      end
    end
    if num_black_neighbors == 0 || num_black_neighbors > 2
      black_tiles_to_flip << k
    end
  end
  adjacent_white_tiles.uniq!
  white_tiles_to_flip = []
  adjacent_white_tiles.each do |x, y|
    num_black_neighbors = 0
    neighbors(x, y) do |tile|
      num_black_neighbors += 1 if state[tile]
    end
    if num_black_neighbors == 2
      white_tiles_to_flip << [x, y]
    end
  end
  (black_tiles_to_flip + white_tiles_to_flip).each do |t|
    state[t] = !state[t]
  end
end

puts "There are #{state.filter { |k,v| v}.count} black tiles."
