#!/usr/bin/ruby

require_relative '../lib.rb'

seats = IO.readlines("data/day11input.txt").map(&:chomp).map{ |r| r.chars }

def adjacent_empty(seats, i, j)
  n = 0
  [-1, 0, 1].each do |di|
    [-1, 0, 1].each do |dj|
      next if di == 0 && dj == 0
      ip = i
      jp = j
      while true
        ip += di
        jp += dj
        break if ip < 0 || jp < 0 || ip >= seats.size || jp >= seats[ip].size
        if seats[ip][jp] != '.'
          n += 1 if seats[ip][jp] == '#'
          break
        end
      end
    end
  end
  n
end

def next_state(seats, i, j)
  case seats[i][j]
  when '.'
    '.'
  when 'L'
    if adjacent_empty(seats, i, j) == 0
      '#'
    else
      'L'
    end
  when '#'
    if adjacent_empty(seats, i,j ) >= 5
      'L'
    else
      '#'
    end
  else
    raise 'wut?'
  end
end

while true
  changed = false
  next_seats = []
  (0..seats.size - 1).each do |i|
    next_seats << []
    (0..seats[i].size - 1).each do |j|
      ns = next_state(seats, i, j)
      next_seats[i] << ns
      changed ||= ns != seats[i][j]
    end
  end
  seats = next_seats
  break unless changed
end

puts seats.flatten.keep_if {|x| x == '#'}.size
