#!/usr/bin/ruby

require_relative '../lib.rb'

p1l, p2l = IO.readlines_blank_separated("data/day22input.txt")

p1 = p1l.drop(1).map(&:to_i)
p2 = p2l.drop(1).map(&:to_i)

$game = 1

def game(p1, p2)
  # puts "Game #{$game}..."
  hsh = {}
  winner = nil
  until (p1.empty? || p2.empty?)
    if hsh[[p1, p2]]
      # puts "Player 1 wins by default"
      winner = :p1
      break
    else
      hsh[[p1, p2]] = true
    end
    t1 = p1.shift
    t2 = p2.shift
    if p1.size >= t1 && p2.size >= t2
      $game += 1
      winner = game(p1.slice(0, t1), p2.slice(0, t2))
      # puts "#{winner} wins by subgame"
    else
      winner = (t1 > t2) ? :p1 : :p2
      # puts "#{winner} wins by score #{t1} vs #{t2}"
    end
    if winner == :p1
      p1 << t1 << t2
    else
      p2 << t2 << t1
    end
  end
  winner
end
game(p1, p2)

sum = 0
(p1 + p2).reverse.each_with_index do |x,i|
  sum += x * (i + 1)
end

puts [p1, p2].inspect
puts sum
