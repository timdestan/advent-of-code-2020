#!/usr/bin/ruby

require_relative '../lib.rb'

inputs = IO.read("data/day15input.txt").split(',').map(&:to_i)

curr = nil
nextval = nil
last = []
t = 0
n = 30000000
while t < n
  curr = (t < inputs.size) ? inputs[t] : nextval
  nextval = last[curr] ? (t - last[curr]) : 0
  last[curr] = t
  t += 1
end
puts "Final: #{curr}"
