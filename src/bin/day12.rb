#!/usr/bin/ruby

require_relative '../lib.rb'

wp_x = 10
wp_y = 1

x = 0
y = 0

def deg2rad(degrees)
  degrees * Math::PI / 180
end

IO.readlines("data/day12input.txt").map(&:chomp).each do |line|
   raise "bad line" unless line =~ /(\w)(\d+)/
   letter = $1
   num = $2.to_i
   case letter
   when "N"
    wp_y += num
   when "S"
    wp_y -= num
   when "E"
    wp_x += num
   when "W"
    wp_x -= num
   when "L", "R"
    num *= -1 if letter == "R"
    rads = deg2rad(num)
    cos = Math.cos(rads).round
    sin = Math.sin(rads).round
    wp_x, wp_y = [wp_x * cos - wp_y * sin, wp_y * cos + wp_x * sin]
   when "F"
    x += wp_x * num
    y += wp_y * num
   else
    raise "unexpected letter"
   end
   puts "#{line}: ship: (#{x},#{y}) waypoint: (#{wp_x}, #{wp_y})"
end

puts "Final: (#{x},#{y}) dist = #{x.abs + y.abs}"
