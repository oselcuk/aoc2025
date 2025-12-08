
# Preserved for posterity

# lines = File.readlines(ARGV[0], chomp: true)
# beams = [lines[0].index("S")]
# part1 = lines[1..].map do |line|
#   splitters = line.length.times.select{ |i| line[i] == '^' }
#   splits = beams & splitters
#   beams = (beams - splits) | splits.flat_map { |i| [i-1, i+1] }
#   splits.size
# end.sum

# puts "Part 1: #{part1}"


lines = File.readlines(ARGV[0], chomp: true)
beams = {lines[0].index("S") => 1}
beams.default = 0
splits = 0

lines[1..].each do |line|
  splitters = line.length.times.select{ |i| line[i] == '^' }
  new_beams = {}
  new_beams.default = 0
  beams.each do |col, paths| 
    if splitters.index(col) then
      new_beams[col-1] += paths
      new_beams[col+1] += paths
      splits += 1
    else
      new_beams[col] += paths
    end
  end
  beams = new_beams
end

paths = beams.values.sum

puts "Part 1: #{splits}"
puts "Part 2: #{paths}"