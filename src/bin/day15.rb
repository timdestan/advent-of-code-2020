#!/usr/bin/ruby

require_relative '../lib.rb'

inputs = IO.read("data/day15input.txt").split(',').map(&:to_i)

curr = nil
nextval = nil
last = {}
(0 .. (30000000 - 1)).each do |t|
  curr = (t < inputs.size) ? inputs[t] : nextval
  nextval = last[curr] ? (t - last[curr]) : 0
  last[curr] = t
  # puts "Turn #{t+1}: #{curr}"
end
puts "Final: #{curr}"
