#!/usr/bin/ruby

require_relative '../lib.rb'

# part 1
#
# $mask1 = 0
# $mask0 = 0
# $mem = {}
#
# IO.readlines("data/day14input.txt").map(&:chomp).each do |line|
#   if line =~ /^mask = (.+)$/
#     $mask1 = 0
#     $mask0 = 0
#     n = 1
#     $1.chars.reverse.each do |c|
#       if c == '0'
#         $mask0 |= n
#       elsif c == '1'
#         $mask1 |= n
#       elsif c == 'X'
#         # noop
#       else
#         raise "bad char #{c}"
#       end
#       n <<= 1
#     end
#     puts "m1 = #{$mask1} m0 = #{$mask0}"
#   elsif line =~ /^mem\[(\d+)\] = (\d+)$/
#     puts "Value = #{$2}"
#     puts "Result = #{($2.to_i | $mask1) & ~$mask0}"

#     $mem[$1.to_i] = ($2.to_i | $mask1) & ~$mask0
#   end
# end
# puts $mask1, $mask0
# puts $mem
# puts $mem.values.sum

$mask1 = 0
$xmasks = []
$mem = {}

IO.readlines("data/day14input.txt").map(&:chomp).each do |line|
  if line =~ /^mask = (.+)$/
    $mask1 = 0
    $xmasks = []
    n = 1
    $1.chars.reverse.each do |c|
      if c == '0'
        # noop
      elsif c == '1'
        $mask1 |= n
      elsif c == 'X'
        $xmasks << n
      else
        raise "bad char #{c}"
      end
      n <<= 1
    end
    puts "m1 = #{$mask1} xmasks = #{$xmasks.inspect}"
  elsif line =~ /^mem\[(\d+)\] = (\d+)$/
    addrs = [$1.to_i | $mask1]
    value = $2.to_i

    $xmasks.each do |x|
      addrs = addrs.map {|addr| [addr | x, addr & ~x] }.flatten
    end

    addrs.each do |addr|
      $mem[addr] = value
    end
  end
end
# puts $mem
puts $mem.values.sum
