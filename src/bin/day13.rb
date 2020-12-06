#!/usr/bin/ruby

require_relative '../lib.rb'

l1,l2 = IO.readlines("data/day13input.txt").map(&:chomp)

# part 1
# t0 = l1.to_i
# buses = l2.split(',').keep_if {|x| x!='x'}.map(&:to_i)
# buses = buses.map { |x| (1..10000).map { |i| {:bus=>x, :t=>x * i} }}.flatten.keep_if{|x| x[:t] >= t0}.sort { |a,b| a[:t] <=> b[:t] }
# bus = buses[0]
# puts bus[:bus] * (bus[:t] - t0)

reqs = []
l2.split(',').each_with_index do |x,i|
  reqs << {:offset=>i, :bus=>x.to_i} unless x == 'x'
end
reqs.sort! {|x,y| x[:bus] <=> y[:bus] }
puts "reqs = #{reqs.inspect}"

def validate(rs, t)
  rs.map do |r|
    (t + r[:offset]) % r[:bus] == 0
  end.reduce(&:&)
end

def find_meet(rs, t, dt)
  loop do
    break if validate(rs, t)
    t += dt
  end
  t
end

rs = []
t = 0
lcm = 0
reqs.each do |r|
  rs << r
  if rs.size >= 2
    if t == 0
      t = find_meet(rs, t, 1)
      lcm = rs.map { |r| r[:bus] }.reduce(&:lcm)
    else
      puts "t = #{t}, rs = #{rs.inspect}, lcm = #{lcm}"
      t = find_meet(rs, t, lcm)
      lcm = rs.map { |r| r[:bus] }.reduce(&:lcm)
    end
  end
end

# Ugh, this could have been made much simpler, but leaving the
# first version I got working in the spirit of documenting the process.
# The simpler version would be:
#
# rs = []
# t = 0
# lcm = 1
# reqs.each do |r|
#   rs << r
#   puts "t = #{t}, rs = #{rs.inspect}, lcm = #{lcm}"
#   t = find_meet(rs, t, lcm)
#   lcm = rs.map { |r| r[:bus] }.reduce(&:lcm)
# end

puts "lcm = #{lcm}, t = #{t}"
t -= (t / lcm) * t
puts "t = #{t}"
