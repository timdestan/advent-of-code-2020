#!/usr/bin/ruby

$pps = []
p = {}

IO.readlines("data/day04input.txt").each do |line|
  line.chomp!
  if line.empty?
    $pps << p
    p = {}
  else
    line.split(/\s+/).each do |part|
      key, val = part.split(':')
      p[key] = val
    end
  end
end
unless p.empty?
  $pps << p
end

valid = 0
$pps.each do |pp|
  next unless (
  pp.include?("byr") &&
  pp.include?("iyr") &&
  pp.include?("eyr") &&
  pp.include?("hgt") &&
  pp.include?("hcl") &&
  pp.include?("ecl") &&
  pp.include?("pid"))

  begin
    x = Integer(pp["byr"])
    next if x < 1920 || x > 2002
  rescue
    next
  end

  begin
    x = Integer(pp["iyr"])
    next if x < 2010 || x > 2020
  rescue
    next
  end

  begin
    x = Integer(pp["eyr"])
    next if x < 2020 || x > 2030
  rescue
    next
  end

  if pp['hgt'] =~ /^(\d+)cm$/
    next if $1.to_i < 150 || $1.to_i > 193
  elsif pp['hgt'] =~ /(^\d+)in$/
    next if $1.to_i < 59 || $1.to_i > 76
  else
    next
  end

  unless pp['hcl'] =~ /^#[0-9a-f]{6}$/
    next
  end

  unless %w{amb blu brn gry grn hzl oth}.include? pp['ecl']
    next
  end

  unless pp['pid'] =~ /^[0-9]{9}$/
    next
  end

  valid += 1
end

puts "#{valid} are valid"
