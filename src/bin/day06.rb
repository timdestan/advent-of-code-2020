#!/usr/bin/ruby

require_relative '../lib.rb'

a = IO.readlines_blank_separated("data/day06input.txt").map{|grp| grp.map(&:chars)}

part1 = a.map { |grp|
  grp.flatten.uniq.size
}.reduce(&:+)

part2 = a.map { |grp|
  grp.reduce(&:&).size
}.reduce(&:+)

puts "part1 = #{part1}, part2 = #{part2}"
