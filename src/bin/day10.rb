#!/usr/bin/ruby

require_relative '../lib.rb'

$nums = IO.readlines("data/day10input.txt").map(&:to_i)

$nums << 0
$nums << $nums.max + 3
$nums.sort!

$tbl = {}
def paths(i, j)
  key = [i,j]
  if $tbl[key].nil?
    if i == j
      $tbl[key] = 1
    else
      npaths = 0
      [i+1, i+2, i+3].each do |i2|
        next if i2 > j
        if $nums[i2] - $nums[i] <= 3
          npaths += paths(i2, j)
        end
      end
      $tbl[key] = npaths
    end
  end
  $tbl[key]
end

puts paths(0, $nums.size - 1)
