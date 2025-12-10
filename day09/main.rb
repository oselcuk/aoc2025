
def area(a, b)
  ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
end

part1 = File.readlines(ARGV[0], chomp: true)
  .map{ |line| line.split(',').map(&:to_i) }
  .combination(2)
  .map{ |a, b| area a, b }
  .sort
  .last

puts "Part 1: #{part1}"