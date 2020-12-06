#!/usr/bin/ruby

require_relative '../lib.rb'

$inst = []

IO.readlines("data/day08input.txt").each do |line|
  line.chomp!
  if line =~ /nop (\+|\-)(\d+)/
    n = $2.to_i
    n *= -1 if $1 == '-'
    $inst << [:nop, n]
  elsif line =~ /acc (\+|\-)(\d+)/
    n = $2.to_i
    n *= -1 if $1 == '-'
    $inst << [:acc, n]
  elsif line =~ /jmp (\+|\-)(\d+)/
    n = $2.to_i
    n *= -1 if $1 == '-'
    $inst << [:jmp, n]
  else
    puts "what"
  end
end
puts $inst.inspect

$inst.each_with_index do |inst, i|
  inst = $inst[i]
  case inst[0]
  when :jmp
    inst[0] = :nop
  when :nop
    inst[0] = :jmp
  else
    next
  end

  $seen = {}
  x = 0
  i = 0
  good = true
  while i < $inst.size
    pc = $inst[i]
    if $seen.include? i
      good = false
      break
    else
      $seen[i] = true
    end

    case pc[0]
    when :nop
      i += 1
      next
    when :acc
      x += pc[1]
      i += 1
      next
    when :jmp
      i += pc[1]
      next
    end
  end
  if good
    puts "good: #{x}"
    exit(0)
  end

  # restore
  case inst[0]
  when :jmp
    inst[0] = :nop
  else
    inst[0] = :jmp
  end
end
