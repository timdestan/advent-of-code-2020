#!/usr/bin/ruby

require_relative '../lib.rb'

nmoves = 10_000_000

cups = IO.read("data/day23input.txt").chomp.split('').map(&:to_i)
cups += (cups.max + 1 .. 1_000_000).to_a
ncups = cups.size

prev = nil
next_cup = []
cups.each do |c|
  unless prev.nil?
    next_cup[prev] = c
  end
  prev = c
end
next_cup[prev] = cups[0]

curr = cups[0]
cups = nil

move = 1
while move <= nmoves
  # Find cups to move (x, y, z).
  x = next_cup[curr]
  y = next_cup[x]
  z = next_cup[y]
  i = curr - 2
  while true
    dest = i % ncups + 1
    unless dest == x || dest == y || dest == z
      break
    end
    i -= 1
  end

  tmp = next_cup[dest]
  next_cup[curr] = next_cup[z]
  next_cup[dest] = x
  next_cup[x] = y
  next_cup[y] = z
  next_cup[z] = tmp

  curr = next_cup[curr]
  move += 1
end

x = next_cup[1]
y = next_cup[x]
puts "order = #{x} * #{y} = #{x * y}"
