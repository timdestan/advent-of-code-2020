
def time(cmd)
  $stderr.puts "Benchmarking `#{cmd}`..."
  times = []
  3.times do
    output = `(/usr/bin/time -p #{cmd}) 2>&1`
    fail("no match for #{cmd}") unless output =~ /real\s+((?:\d|\.)+)/
    times << $1.to_f
  end
  times.sum / times.size
end

system('cargo build --release')

results = []

Dir["src/bin/*.rb"].each do |f|
  results << [f, time("ruby #{f}")]
end

Dir["src/bin/*.rs"].each do |f|
  bin = File.basename(f).sub(/[.]rs/, '')
  results << [f, time("target/release/#{bin}")]
end

results.sort_by {|k,v| -v}.each do |k,v|
  puts "%.2fs %s" % [v, k]
end
