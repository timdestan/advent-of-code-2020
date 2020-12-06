#!/usr/bin/ruby

(puts "usage #{$0} num" ; exit(0)) unless ARGV.length == 1

num = ARGV[0]
formatted = "%02d" % [num]

`touch data/day#{formatted}input.txt`
`touch src/bin/day#{formatted}.rb`

puts "Initialized day#{formatted} files."
