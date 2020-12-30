#!/usr/bin/ruby

require_relative '../lib.rb'

$nmoves = 10_000_000

cups = IO.read("data/day23input.txt").chomp.split('').map(&:to_i)
cups += (cups.max + 1 .. 1_000_000).to_a
n = cups.size

prev = nil
$next = []
cups.each do |c|
  unless prev.nil?
    $next[prev] = c
  end
  prev = c
end
$next[prev] = cups[0]

$sorted = cups.sort
curr = cups[0]
cups = nil

def find_dest(curr, excluded)
  i = curr - 2
  loop do
    x = $sorted[i % $sorted.size]
    unless excluded.include? x
      return x
    end
    i = (i - 1) % $sorted.size
  end
end

def find_to_move(curr)
  arr = []
  3.times do
    arr << $next[curr]
    curr = $next[curr]
  end
  arr
end

$move = 1
$nmoves.times do
  # puts "-- move #{$move} --"
  # puts "cups: #{$cups.map.with_index {
  #   |c,i| i == curr ? "(#{c})" : c.to_s
  # }.join(' ')}"
  # puts "next = #{$next.inspect}"
  to_move = find_to_move(curr)
  # puts "pick up: #{to_move.map(&:to_s).join(', ')}"
  dest = find_dest(curr, to_move)
  # puts "destination: #{dest}"

  tmp = $next[dest]
  x, y, z = to_move
  $next[curr] = $next[z]
  $next[dest] = x
  $next[x] = y
  $next[y] = z
  $next[z] = tmp

  curr = $next[curr]
  $move += 1
end

x = $next[1]
y = $next[x]
puts "order = #{x} * #{y} = #{x * y}"
