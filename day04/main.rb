rolls = File.readlines(ARGV[0], chomp: true).map {|line| ".#{line}."}
filler = "." * rolls[0].length
rolls = [filler, *rolls, filler]

def find_removable_rolls(rolls)
  (1..rolls.length-2).to_a.product((1..rolls[0].length-2).to_a).filter do |i, j|
    adj = (-1..1).to_a
    neighbors = adj.product(adj)
    rolls[i][j] == "@" && neighbors.map{|ii, jj| rolls[i+ii][j+jj]}.count("@") < 5
  end
end

def remove_rolls(rolls, coords) coords.each {|i, j| rolls[i][j] = "X"} end

to_remove = find_removable_rolls(rolls)
puts "Part 1: #{to_remove.length}"

removed = 0
until to_remove.empty? do
  removed += to_remove.length
  remove_rolls rolls, to_remove
  to_remove = find_removable_rolls rolls
end
puts "Part 2: #{removed}"
