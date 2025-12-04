part1 = 0
part2 = 0
File.foreach(ARGV[0], ',', chomp: true) do |pair|
  l, r = pair.split('-').map &:to_i
  # puts("l: #{l} r: #{r}")
  (l..r).each do |num|
    # puts "Checking #{num}"
    len = Math.log10(num).floor + 1
    invalid = (len/2).downto(1).any? do |repeat_len|
      unless len % repeat_len == 0 then 
        next false
      end
      rem = num
      div = 10 ** repeat_len
      repeat = rem % div
      rem /= div while repeat == rem % div
      part1 += num if rem == 0 && repeat_len == len / 2 && len % 2 == 0
      rem == 0
    end
    part2 += num if invalid
    # puts "Checked #{num}"
  end
  # puts "Checked #{pair}"
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"