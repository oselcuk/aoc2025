
DEBUG_LEVEL = ARGV.length > 1 ? ARGV[1].to_i : 0

def area(a, b)
  ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
end

points = File.readlines(ARGV[0], chomp: true)
  .map{ |line| line.split(',').map(&:to_i) }

part1 = points
  .combination(2)
  .map{ |a, b| area a, b }
  .sort
  .last

puts "Part 1: #{part1}"


def gen_map(points, debug: 0)
  mx = points.map{|v, _| v}.max + 2
  my = points.map{|_, v| v}.max + 2
  puts "points #{points} mx #{mx} my #{my}" if debug > 1
  edges = Array.new(mx){ Array.new(my, false) }
  map = Array.new(mx){ Array.new(my, true) }

  points.chain(points[..0]).each_cons(2) do |(x1, y1), (x2, y2)|
    x1, x2 = [x1, x2].sort
    y1, y2 = [y1, y2].sort
    (x1..x2).each{|x| edges[x][y1] = true} if y1 == y2
    (y1..y2).each{|y| edges[x1][y] = true} if x1 == x2
    puts "Connected #{[x1, y1]} to #{[x2, y2]}" if debug > 1
    puts mx.times.map{|x| my.times.map{|y| edges[x][y] ? '#' : '.'}.join}.join("\n") if debug > 1
  end

  stack = [[0,0]]
  flood_fill = ->(x, y) do
    return if x < 0 || x >= mx || y < 0 || y >= my
    return if !map[x][y] || edges[x][y]
    map[x][y] = false
    [[1,0], [-1, 0], [0, 1], [0, -1]].each{|dx, dy| stack.push([x+dx, y+dy])}
  end
  while !stack.empty? do flood_fill.call(*stack.pop) end

  puts "Final map:" if debug > 0
  puts my.times.map{|y| mx.times.map{|x| map[x][y] ? '#' : '.'}.join}.join("\n") if debug > 0
  map
end

gen_map(points, debug: DEBUG_LEVEL) if DEBUG_LEVEL > 0

x_map = points.map{|x, _| x}.sort.uniq.each_with_index.map{|v, i| [v, i+1]}.to_h
y_map = points.map{|_, y| y}.sort.uniq.each_with_index.map{|v, i| [v, i+1]}.to_h

points = points.map{|x, y| [x_map[x], y_map[y]]}
x_map = x_map.invert
y_map = y_map.invert

map = gen_map(points, debug: DEBUG_LEVEL)
decode = ->((x, y)) { [x_map[x], y_map[y]] }
decoded_area = ->((a, b)) {area(decode.call(a), decode.call(b))}
is_valid = ->(((x1, y1), (x2, y2))) do
  Range.new(*[x1, x2].minmax).all? {|x| Range.new(*[y1, y2].minmax).all? {|y| map[x][y]}}
end

part2 = points
  .combination(2)
  .sort_by{ |pair| -decoded_area.call(pair)}
  .lazy
  .filter{ |pair| is_valid.call(pair) }
  .first

p part2[0] if DEBUG_LEVEL > 0
p part2[1] if DEBUG_LEVEL > 0

puts "Part 2: #{decoded_area.call part2}"



# sx, sy = points[1]
# sx -= ((sx <=> points[0][0]) + (sx <=> points[2][0]))
# sy -= ((sy <=> points[0][1]) + (sy <=> points[2][1]))
# p [sx, sy]
# p x_map[sx]
# p y_map[sy]