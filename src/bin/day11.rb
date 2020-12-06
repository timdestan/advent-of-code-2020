#!/usr/bin/ruby

require_relative '../lib.rb'

$seats = IO.readlines("data/day11input.txt").map(&:chomp).map{ |r| r.chars }

def adjacent(i, j)
  # trace = i == 1 && j == 8
  # puts "curr = #{$seats[i][j]}" if trace
  arr = []
  [-1, 0, 1].each do |di|
    [-1, 0, 1].each do |dj|
      # puts "processing #{[di, dj].inspect}" if trace
      next if di == 0 && dj == 0
      ip = i
      jp = j
      loop do
        ip += di
        jp += dj
        break if ip < 0 || jp < 0 || ip >= $seats.size || jp >= $seats[ip].size
        if $seats[ip][jp] != '.'
          # puts "Found #{$seats[ip][jp]}" if trace
          arr << $seats[ip][jp]
          break
        end
      end
    end
  end
  arr
end

def adjacent_empty(i, j)
  adjacent(i,j).keep_if { |x| x == '#' }.size
end

def next_state(i, j)
  case $seats[i][j]
  when '.'
    '.'
  when 'L'
    if adjacent_empty(i,j) == 0
      '#'
    else
      'L'
    end
  when '#'
    if adjacent_empty(i,j) >= 5
      'L'
    else
      '#'
    end
  else
    raise 'wut?'
  end
end

loop do
  # puts $seats.map{|r| r.join('')}.join("\n")
  # puts
  changed = false
  next_seats = []
  ae = []
  (0..$seats.size - 1).each do |i|
    next_seats << []
    ae << []
    (0..$seats[i].size - 1).each do |j|
      ns = next_state(i, j)
      ae[i] << adjacent_empty(i, j)
      next_seats[i] << ns
      changed = true if ns != $seats[i][j]
    end
  end
  # puts ae.map{|x| x.join(',')}.join("\n")
  # puts
  $seats = next_seats
  break unless changed
end

puts $seats.flatten.keep_if {|x| x == '#'}.size
