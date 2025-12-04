

def joltage(digits, batteries, cur=0)
  if digits == 0 then
    cur
  else
    num = batteries[..-digits].max
    index = batteries.index num
    joltage(digits-1, batteries[index+1..], cur*10+num)
  end
end

banks = File.readlines(ARGV[0], chomp: true).map {|line| line.chars.map(&:to_i)}
part1 = banks.map{|bank| joltage(2, bank)}.sum
part2 = banks.map{|bank| joltage(12, bank)}.sum
# part1 = File.readlines(ARGV[0], chomp: true).map do |line|
  # nums = line.chars.map &:to_i
  # max = nums.max
  # index = nums.index(max)
  # if index == nums.length - 1 then
  #   nums[...-1].max * 10 + max
  # else
  #   max * 10 + nums[index+1..].max
  # end
# end.sum
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"