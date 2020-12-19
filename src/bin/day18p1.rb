#!/usr/bin/ruby

require_relative '../lib.rb'

lines = IO.readlines("data/day18input.txt").map(&:chomp)

tokenses = lines.map do |line|
  root_tokens = []
  tokens = root_tokens
  stk = []
  line.chars.each do |c|
    next if c == ' '
    case c
    when '+', '*'
      tokens << c.to_sym
    when /\d/
      tokens << c.to_i
    when '('
      a = []
      tokens << a
      stk << tokens
      tokens = a
    when ')'
      tokens = stk.pop
    else
      fail('bad token')
    end
  end
  root_tokens
end

def eval(tokens)
  fail('empty') if tokens.empty?
  val = nil
  op = nil
  tokens.each do |t|
    if t.is_a? Symbol
      op = t
    else
      newval = (t.is_a? Integer) ? t : eval(t)
      if val.nil?
        val = newval
      else
        val = val.method(op).call(newval)
      end
      # puts " => #{val}"
    end
  end
  val
end

puts tokenses.map{|ts| eval(ts)}.reduce(&:+)
