#!/usr/bin/ruby

require_relative '../lib.rb'

paths = []
n1, n2 = IO.readlines("data/day25input.txt").map(&:to_i)

def find_loop_size(value)
  n = 0
  x = 1
  while true
    x = (x * 7) % 20201227
    n += 1
    return n if x == value
  end
end

def run_loop(s, n)
  x = 1
  i = 0
  while i < n
    x = (x * s) % 20201227
    i += 1
  end
  x
end

size = find_loop_size(n1)
puts run_loop(n2, size)
