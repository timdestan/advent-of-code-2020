#!/usr/bin/ruby

require 'set'

require_relative '../lib.rb'

$groupings = {}
$ilists = []
IO.readlines("data/day21input.txt").each do |line|
  fail 'bad line' unless line =~ /^(.+) \(contains (.+)\)$/
  ingredients = $1.split(' ')
  allergens = $2.split(', ')
  $ilists << ingredients
  allergens.each do |a|
    $groupings[a] ||= []
    $groupings[a] << ingredients
  end
end

$good_ingredients = $groupings.values.flatten.uniq
$reduced_groupings = {}
$groupings.each do |a, lists|
  possible = lists.reduce(&:&)
  possible.each do |common|
    $good_ingredients.delete(common)
  end
  $reduced_groupings[a] = possible
end

puts $reduced_groupings.inspect

good_count = 0
$ilists.flatten.each do |i|
  good_count += 1 if $good_ingredients.include? i
end

puts "Good ingredients appear #{good_count} times."

final = []
allergens = $groupings.keys.to_set
until allergens.empty?
  found = nil
  $reduced_groupings.each do |a, is|
    if is.size == 1
      final << [a, is[0]]
      found = is[0]
      allergens.delete(a)
      break
    end
  end
  fail 'not found' if found.nil?
  $reduced_groupings.each do |a, is|
    is.delete(found)
  end
end

puts final.sort_by {|k,v| k}.map {|k,v| v}.join(',')
