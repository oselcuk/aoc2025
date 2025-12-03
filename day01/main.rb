dial = 50
part1 = 0
part2 = 0
File.foreach(ARGV[0], chomp: true) do |line|
    dir = if line[0] == "R" then 1 else -1 end
    part2 -= 1 if dir == -1 && dial == 0
    num = line[1..].to_i
    dial_raw = dial + dir * num
    dial = dial_raw % 100
    part1 += 1 if dial == 0
    # part2 += (dial_raw / 100).abs
    until dial_raw >= 0 do
        dial_raw += 100
        part2 += 1
    end
    until dial_raw < 100 do
        dial_raw -= 100
        part2 += 1
    end
    part2 += 1 if dir == -1 && dial == 0
    puts "dial: #{dial} dial_raw: #{dial_raw}" if dial != dial_raw
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
