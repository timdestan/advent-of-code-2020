#!/usr/bin/ruby

require_relative '../lib.rb'

rules, examples = IO.readlines_blank_separated("data/day19input.txt")

$rules = {}
rules.each { |r|
  if r =~ /(\d+):\s(.+)$/
    i = $1.to_i
    r = $2
    parts = r.split('|')
    fail if parts.size > 2
    $rules[i] = parts.map { |p|
      p.split(' ')
    }
  else
    fail
  end
}

def build_re(i)
  rule = $rules[i]
  '(?:' + rule.map do |ps|
    ps.map { |p|
      if p == '8'
        "(?:#{build_re(42)})+"
      elsif p == '11'
        lhs = build_re(42)
        rhs = build_re(31)
        # I've done some stuff I ain't proud of, and
        # the stuff I am proud of is disgusting...
        '(?:' + (1..20).map do |i|
          "(?:#{lhs}){#{i}}(?:#{rhs}){#{i}}"
        end.join('|') + ')'
      elsif p =~ /\d+/
        puts "recurse into #{p}"
        build_re(p.to_i)
      else
        p.gsub(/"/,'')
      end
    }.join('')
  end.join('|') + ')'
end

re = Regexp::new('^' + build_re(0) + '$')

# puts re

n = 0
examples.each do |e|
  n += 1 if e =~ re
end

puts n
