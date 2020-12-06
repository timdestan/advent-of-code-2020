#!/usr/bin/ruby

require_relative '../lib.rb'

require 'set'

$child = {}
IO.readlines("data/day07input.txt").each do |line|
  line.chomp!
  next unless line =~ /^(.+) bags? contain (.+)\.$/
  src = $1
  rest = $2.split(',').map(&:chomp).map do |r|
    if r =~ /^\s?(\d+) (.+) bags?/
      [$1.to_i, $2]
    elsif r =~ /no other bags/
      nil
    else
      raise "unexpected"
    end
  end.reject { |x| x.nil? }
  $child[src] = rest
end

n = 0
to_visit = $child['shiny gold'].clone
until to_visit.empty?
  cost, curr = to_visit.pop
  n += cost
  to_visit += ($child[curr] || []).map{|c, x| [c * cost, x] }
end
puts "cost = #{n}"

# Leftover from part 1
#
# all = []
# $child.each do |src, dst|
#   seen = Set.new()
#   to_visit = .clone
#   until to_visit.empty?
#     curr = to_visit.pop
#     ($child[curr] || []).each do |cost, color|
#       seen.add(p)
#       to_visit << p
#       all << p
#     end
#   end
#   n += 1 if all.include? 'shiny gold'
# end
