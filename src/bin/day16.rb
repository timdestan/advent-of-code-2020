#!/usr/bin/ruby

require_relative '../lib.rb'

rules_txt, mine, nearby = IO.readlines_blank_separated("data/day16input.txt")

rules = {}

rules_txt.each do |r|
  if r =~ /(.+):\s(\d+)\-(\d+) or (\d+)\-(\d+)/
    rules[$1] = [
      {:min=> $2.to_i, :max=> $3.to_i},
      {:min=> $4.to_i, :max=> $5.to_i}
    ]
  else
    raise "unexpected rule"
  end
end

# puts rules.values.inspect

def parse_ticket(t)
  t.split(',').map(&:to_i)
end

nearby = nearby.drop(1).map{ |t| parse_ticket(t)}
mine = mine.drop(1).map {|t| parse_ticket(t)}[0]

valid_tickets = nearby.filter do |t|
  t.all? do |value|
    rules.values.flatten.any? do |r|
      value >= r[:min] && value <= r[:max]
    end
  end
end
puts "#{valid_tickets.size} are valid."

field_length = valid_tickets[0].size - 1

pos = {}
rules.each do |name, ranges|
  maybe_valid = (0 .. field_length).to_a
  valid_tickets.each do |ticket|
    ticket.each_with_index do |v, i|
      maybe_valid.delete(i) unless ranges.any? do |r|
        v >= r[:min] && v <= r[:max]
      end
    end
  end
  maybe_valid.each do |v|
    pos[v] ||= []
    pos[v] << name
  end
  # puts "indices for #{name}: #{maybe_valid.inspect}"
end

pos = pos.sort_by {|k,v| v.length}
used_names = {}
final = {}
pos.each do |i, names|
  names.keep_if {|n| !used_names.include? n }
  fail("#{i} => #{names.inspect}") unless names.size == 1
  n = names[0]
  used_names[n] = true
  final[n] = i
end

# puts final
tvals = final.filter {|k,v| k =~ /departure/ }.map do |k,v|
  mine[v]
end

puts "product(#{tvals}) = #{tvals.reduce(&:*)}"
