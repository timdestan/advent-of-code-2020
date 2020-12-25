#!/usr/bin/ruby

require_relative '../lib.rb'

paths = []
IO.readlines("data/day24input.txt").each do |line|
  paths << line.scan(/(e|se|sw|w|nw|ne)/).map { |x| x[0].to_sym }
end
# puts paths.inspect

$deltas = {
  :e => [1, 0],
  :se => [0, -1],
  :sw => [-1, -1],
  :w => [-1, 0],
  :nw => [0, 1],
  :ne => [1, 1]
}

state = Hash.new(false)
paths.each do |path|
  x = 0
  y = 0
  path.each do |p|
    dx, dy = $deltas[p]
    x += dx
    y += dy
  end
  state[[x, y]] = !state[[x, y]]
end

puts "Num flipped: #{state.values.filter{|x| x }.size}"

def neighbors(x, y)
  $deltas.values.map { |dx, dy| [x + dx, y + dy]}
end

$ndays = 100
$ndays.times do |day|
  puts "Day #{day+1}"
  black_tiles = state.filter {|k,v| v}.map { |k,v| k}
  black_tiles_to_flip = []
  adjacent_white_tiles = []
  black_tiles.each do |x, y|
    ns = neighbors(x, y)
    # puts "x = #{x}, y = #{y}, ns = #{ns.inspect}"

    adjacent_white_tiles += ns.filter {|x, y|
      !state[[x,y]]
    }
    num_black_neighbors = ns.filter {|x, y| state[[x,y]]}.size
    if num_black_neighbors == 0 || num_black_neighbors > 2
      black_tiles_to_flip << [x, y]
    end
  end
  adjacent_white_tiles.uniq!
  white_tiles_to_flip = []
  adjacent_white_tiles.each do |x, y|
    ns = neighbors(x, y)
    # puts "x = #{x}, y = #{y}, ns = #{ns.inspect}"
    num_black_neighbors = ns.filter {|x, y| state[[x,y]]}.size
    if num_black_neighbors == 2
      white_tiles_to_flip << [x, y]
    end
  end
  fail('overlap') unless (black_tiles_to_flip & white_tiles_to_flip).empty?
  (black_tiles_to_flip + white_tiles_to_flip).each do |x, y|
    state[[x, y]] = !state[[x, y]]
  end
  # puts "bt: #{black_tiles.inspect}"
  # puts "awt: #{adjacent_white_tiles.inspect}"
  # puts "bttf: #{black_tiles_to_flip.inspect}"
  # puts "wttf: #{white_tiles_to_flip.inspect}"
  puts "There are #{state.filter { |k,v| v}.count} black tiles."
end
