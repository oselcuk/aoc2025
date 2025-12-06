load "../shared/shared.rb"

ranges, ids = File.readlines(ARGV[0], chomp: true).split_at("")
ids = ids.map &:to_i

def combine_range(a, b) [a.first, b.first].min .. [a.last, b.last].max end

ranges = ranges.map{|range| range.split("-").map(&:to_i)}.sort.map{|i, j| i..j}
  .reduce [] do |(*list, last), range|
    if last == nil then
      [range]
    elsif last.overlap? range then
      [*list, combine_range(last, range)]
    else
      [*list, last, range]
    end
  end

part1 = ids.filter {|id| ranges.any? {|range| range.cover? id}}.length
part2 = ranges.map(&:count).sum

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"