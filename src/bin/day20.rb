#!/usr/bin/ruby

require_relative '../lib.rb'

def parse_id(line)
  if line =~ /Tile (\d+):/
    $1.to_i
  else
    fail 'bad id'
  end
end

Block = Struct.new(:id, :data) do
  def top ; data[0] ; end
  def right ; data.map { |r| r.last } ; end
  def bottom ; data.last ; end
  def left ; data.map { |r| r[0] } ; end

  def sides
    [top, right, bottom, left]
  end

  # A B C
  # 1 2 3
  # D E F
  # ====>
  # D 1 A
  # E 2 B
  # F 3 C
  def rotate_right
    Block.new(id, (0..data.size-1).map { |i|
      data.map {|r| r[i]}.reverse
    })
  end

  def flip_horizontal
    Block.new(id, data.map {|r| r.reverse})
  end

  def flip_vertical
    Block.new(id, data.reverse)
  end
end

blocks =
  IO.readlines_blank_separated("data/day20input.txt")
    .map do |b|
      id = parse_id(b[0])
      Block.new(id, b.drop(1).map {|r| r.chars }.to_a)
    end

def canonicalize(side)
  i = 0
  j = side.size - 1
  while i < j
    case side[i] <=> side[j]
    when -1
      return side
    when 1
      return side.reverse
    end
    i += 1
    j -= 1
  end
  side
end

$by_cside = {}
blocks.each do |t|
  t.sides.each do |s|
    ($by_cside[canonicalize(s)] ||= []) << t
  end
end

# puts $by_cside.values.map{|vs| vs.size }.sort.inspect

corners = []
blocks.each do |t|
  matching = 0
  t.sides.each do |s|
    matching += 1 if $by_cside[canonicalize(s)].size > 1
  end
  corners << t if matching == 2
end
# part 1
# puts corners.map(&:id).reduce(&:*)

N = blocks[0].data.size
M = Math.sqrt(blocks.size).to_i
L = (N-2)*M
$image = Array.new(L) { Array.new(L) }

def write_to_image(block, i0, j0)
  (0..N-3).each do |i|
    (0..N-3).each do |j|
      # raise('overwrite') unless $image[i0+i][j0+j].nil?
      $image[i0+i][j0+j] = block.data[i+1][j+1]
    end
  end
end

puts "N = #{N}, M = #{M}, L = #{L}"

def write_row(s, i)
  j = 0
  loop do
    puts "  write_image(#{i},#{j})"
    write_to_image(s, i, j)
    cs = canonicalize(s.right)
    next_s = $by_cside[cs].filter { |x| x.id != s.id }[0]
    break if next_s.nil?
    while canonicalize(next_s.left) != cs
      next_s = next_s.rotate_right
    end
    if next_s.left != s.right
      next_s = next_s.flip_vertical
    end
    fail unless next_s.left == s.right
    s = next_s
    j += (N - 2)
  end
end

s = corners[0]
while $by_cside[canonicalize(s.top)].size > 1 ||
      $by_cside[canonicalize(s.left)].size > 1
  s = s.rotate_right
end
i = 0
j = 0
loop do
  puts "write_row(#{i})"
  write_row(s, i)
  cs = canonicalize(s.bottom)
  next_s = $by_cside[cs].filter { |x| x.id != s.id }[0]
  break if next_s.nil?
  while canonicalize(next_s.top) != cs
    next_s = next_s.rotate_right
  end
  if next_s.top != s.bottom
    next_s = next_s.flip_horizontal
  end
  fail unless next_s.top == s.bottom
  s = next_s
  i += (N - 2)
end

puts $image.map { |r| r.join('') }.join("\n")

image = Block.new(42, $image)

def all_rotations(block)
  x = block
  arr = []
  4.times do
    arr << x
    x = x.rotate_right
  end
  arr
end

ar = all_rotations(image)
all = ar + ar.map { |x| x.flip_horizontal }

SEA_MONSTER =
  ["                  # ",
   "#    ##    ##    ###",
   " #  #  #  #  #  #   "].map(&:chars)
SEA_MONSTER_HASH_COUNT =
  SEA_MONSTER.flatten.filter {|x| x == '#'}.size

def is_sea_monster(data, i0, j0)
  SEA_MONSTER.each_with_index do |r,i|
    r.each_with_index do |x,j|
      return false if x == '#' && data[i0+i][j0+j] != '#'
    end
  end
  true
end

def count_sea_monsters(block)
  data = block.data
  count = 0
  (0..L-2-SEA_MONSTER.size).each do |i|
    (0..L-2-SEA_MONSTER[0].size).each do |j|
      count += 1 if is_sea_monster(data, i, j)
    end
  end
  count
end

num_sea_monsters = all.map { |x| count_sea_monsters(x) }.max

def count_hashes(block)
  block.data.map {|r| r.filter{|x| x == '#'}.size }.sum
end

puts "There were #{num_sea_monsters} sea monsters."

num_non_sea_monster_hashes =
  count_hashes(image) - SEA_MONSTER_HASH_COUNT * num_sea_monsters
puts "There were #{num_non_sea_monster_hashes} non-sea-monster hashes."
