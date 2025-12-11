
map = File.readlines(ARGV[0], chomp: true).map do |line|
  k, *v = line.split(/:? /)
  [k, v]
end.to_h
map.default = []

paths = {}
paths.default = 0

def count_paths(map, node, target)
  paths = {node => 1}
  paths.default = 0
  stack = [node]
  res = 0
  while !stack.empty? do
    cur = stack.shift
    count = paths.delete(cur)
    res += count if cur == target
    map[cur].each do |nxt|
      paths[nxt] += count
      stack.delete(nxt)
      stack.push(nxt)
    end
  end
  res
end

part1 = count_paths(map, "you", "out")
puts "Part 1: #{part1}"

part21 = count_paths(map, "svr", "fft") * count_paths(map, "fft", "dac") * count_paths(map, "dac", "out")
part22 = count_paths(map, "svr", "dac") * count_paths(map, "dac", "fft") * count_paths(map, "fft", "out")
part2 = part21 + part22
puts "Part 2: #{part2}"