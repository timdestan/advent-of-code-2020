#!/usr/bin/ruby

require_relative '../lib.rb'

lines = IO.readlines("data/day18input.txt").map(&:chomp)

Exp = Struct.new(:lhs, :op, :rhs)

tokenses = lines.map do |line|
  tokens = []
  line.chars.each do |c|
    next if c == ' '
    tokens << c
  end
  tokens
end

Op = Struct.new(:lhs, :op, :rhs)

# A -> B * A | B
# B -> C + B | B
# C -> \d+ | ( A )

class Parser
  def initialize(ts)
    @ts = ts
    @i = 0
  end

  def parse_a
    e1 = parse_b
    if curr == '*'
      op = curr.to_sym
      @i += 1
      e2 = parse_a
      Op.new(e1, op, e2)
    else
      e1
    end
  end

  def parse_b
    e1 = parse_c
    if curr == '+'
      op = curr.to_sym
      @i += 1
      e2 = parse_b
      Op.new(e1, op, e2)
    else
      e1
    end
  end

  def parse_c
    if curr =~ /\d/
      parse_num
    elsif curr == '('
      parse_parens
    else
      fail('failed in parse_c')
    end
  end

  def parse_parens
    expect("(")
    e = parse_a
    expect(")")
    e
  end

  def curr
    @ts[@i]
  end

  def parse_num
    fail('bad num') unless curr =~ /\d+/
    n = curr.to_i
    @i += 1
    n
  end

  def expect(c)
    fail('bad token') unless c == @ts[@i]
    @i += 1
  end
end

def to_sexp(e)
  if e.is_a? Integer
    e
  else
    lhs = to_sexp(e.lhs)
    rhs = to_sexp(e.rhs)
    [e.op, lhs, rhs]
  end
end

def eval_tree(e)
  if e.is_a? Integer
    e
  else
    lhs = eval_tree(e.lhs)
    rhs = eval_tree(e.rhs)
    lhs.method(e.op).call(rhs)
  end
end

puts tokenses.map { |ts|
  to_sexp(Parser.new(ts).parse_a).inspect
}.join("\n")

puts tokenses.map { |ts|
  eval_tree(Parser.new(ts).parse_a)
}.reduce(&:+)
