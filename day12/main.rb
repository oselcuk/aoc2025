load "../shared/shared.rb"

chunks = File.readlines(ARGV[0], chomp: true).split_at("")

shapes = chunks[..-1].map do |lines|
  lines.drop(1).join
end
sizes = shapes.map{|shape| shape.count("#")}
regions = chunks[-1].map do |region|
  size, *counts = region.split(/:? /)
  size = size.split("x").map(&:to_i)
  counts = counts.map(&:to_i)
  {size: size, counts: counts, area: size[0] * size[1]}
end

regions = regions.filter do |region|
  region[:counts].zip(sizes).map{|a, b| a*b}.sum <= region[:area]
end

# This is a dumb first pass filter to remove any regions that obviously
# can't fit all the presents, just by checking if the total areas work
# out. It also happens to solve my full input, not sure if it should tho.
puts "Part 1 upper limit: #{regions.count}"