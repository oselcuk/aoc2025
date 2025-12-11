Machine = Data.define(:indicators, :buttons, :joltage)

machines = File.readlines(ARGV[0], chomp: true).map do |line|
  indicators, buttons, joltage = line.match(/\[([\.#]+)\] ([^\{]+) \{(.+)\}/).deconstruct
  indicators = indicators.gsub('.', '0').gsub('#', '1').reverse.to_i(2)
  buttons = buttons.scan(/\d+(?:,\d+)*/).map{|button| button.split(',').map(&:to_i)}
  joltage = joltage.split(",").map(&:to_i)
  Machine.new(indicators, buttons, joltage)
end

part1 = machines.map do |machine|
  buttons = machine.buttons.map{|is| is.map{|i| 2**i}.reduce(&:|)}
  (1..buttons.length).lazy.filter do |length|
    buttons.combination(length).lazy
      .map{|chosen| chosen.reduce(&:^)}
      .filter{|res| res == machine.indicators}
      .first
  end.first
end

puts "Part 1: #{part1.sum}"


def search(buttons, target, left, last_used=0)
  # p "Target: #{target}, left: #{left}"
  found = target.all?{|i| i == 0}
  wrong = target.any?{|i| i < 0}
  if left == 0 || found || wrong then
    found
  else
    buttons.lazy.each_with_index.drop(last_used).any? do |is, used|
      new_target = target.clone
      is.each{|i| new_target[i]-=1}
      search buttons, new_target, left-1, used
    end
  end
end

part2 = machines.map do |machine|
  (1..).lazy.filter{|count| search(machine.buttons, machine.joltage, count)}.first
end.sum

puts "Part 2: #{part2}"