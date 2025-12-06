
def apply_op(nums, op)
  nums.map(&:to_i).reduce(op == "*" ? :* : :+)
end

raw_lines = File.readlines(ARGV[0], chomp: true)
part1 = raw_lines.map(&:split).transpose.map { |*nums, op| apply_op(nums, op) }.sum

puts "Part 1: #{part1}"

part2 = raw_lines[...-1]
  .map(&:chars)
  .transpose
  .map(&:join)
  .map(&:strip)
  .slice_after("")
  .zip(raw_lines[-1].split)
  .map { |nums, op| apply_op(nums - [""], op) }
  .sum

puts "Part 2: #{part2}"