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

part2 = machines.map do |machine|
  File.open("model.mod", "w") do |model|
    vars = machine.buttons.each_index.map{|i| "x#{i}"}
    sum_expr = vars.join(' + ')
    eqs = machine.joltage.each_with_index.map do |joltage, ji|
      eq = machine.buttons.each_with_index
        .filter_map{|buttons, bi| "x#{bi}" if buttons.include?(ji)}
        .join(" + ")
      eq += " = #{joltage}"
    end
    vars.each{|var| model.puts("var #{var} >= 0, integer;")}
    model.puts("minimize obj: #{sum_expr};")
    eqs.each_with_index{|eq, i| model.puts("s.t. c#{i}: #{eq};")}
    model.puts("solve;")
    model.puts("display #{sum_expr};")
    model.puts("end;")
  end
  # Requires glpsol: pacman -S glpk
  system("glpsol --math model.mod --display model.out", out: File::NULL)
  File.readlines("model.out").last.to_i
end.sum

puts "Part 2: #{part2}"
