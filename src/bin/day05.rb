#!/usr/bin/ruby

nums = []
IO.readlines("data/day05input.txt").each do |line|
  line.chomp!
  nums << line.gsub(/[FL]/, '0').gsub(/[BR]/, '1').to_i(2)
end
nums.sort!
puts "Max seat id: #{nums.max}"
last = nil
nums.each do |n|
  if !last.nil? && last != n-1
    puts "Missing seat id: #{n-1}"
  end
  last = n
end
