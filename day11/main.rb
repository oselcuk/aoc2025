
map = File.readlines(ARGV[0], chomp: true).map do |line|
  k, *v = line.split(/:? /)
  [k, v]
end.to_h

def traverse(map, node)
  if node == "out" then
    1
  else
    map[node].map{|node| traverse(map, node)}.sum
  end
end

part1 = traverse(map, "you")
puts "Part 1: #{part1}"