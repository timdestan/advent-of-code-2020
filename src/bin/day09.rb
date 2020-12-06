#!/usr/bin/ruby

require_relative '../lib.rb'

$nums = IO.readlines("data/day09input.txt").map(&:to_i)

def check(i)
  lo = i - 25
  hi = i - 1
  (lo..hi).each do |i1|
    (i1..hi).each do |i2|
      return true if $nums[i1] + $nums[i2] == $nums[i]
    end
  end
  false
end

def find_invalid_num
  i = 25
  while i < $nums.size
    unless check(i)
      return $nums[i]
    end
    i += 1
  end
  raise "not found"
end

def find_slice(invalid)
  n = $nums.size
  (0..n-1).each do |i|
    total = $nums[i]
    (i+1..n-1).each do |j|
      total += $nums[j]
      if total == invalid
        return [$nums[i,(j - i + 1)], i, j]
      end
    end
  end
end

slice, i, j = find_slice(find_invalid_num)
puts slice.minmax.reduce(&:+)
