# TODO: Extract the disjoint set to a separate class if needed again
class Circuit
  attr_accessor :coords, :parent, :size

  def initialize(coords)
    @coords = coords
    @parent = self
    @size = 1
  end

  def distance(other)
    @coords.zip(other.coords).map{|l, r| (l-r)**2}.sum
  end

  def root
    if @parent == self then
      self
    else
      @parent = @parent.root
    end
  end

  def union(other)
    if joint? other then
      nil
    else
      new_root = other.root.parent
      old_root = root
      # p "union #{@coords} #{other.coords} (#{new_root.size} + #{old_root.size})"
      new_root.size += old_root.size
      old_root.parent = new_root
      [self, other]
    end
  end

  def joint?(other)
    # p "joint? #{@coords} #{other.coords}"
    root == other.root
  end
end


steps = (ARGV[1] || 1000).to_i
circuits = File.readlines(ARGV[0], chomp: true).map{|line| Circuit.new(line.split(',').map(&:to_i))}

# circuits.combination(2).sort_by{|a, b| a.distance b}.lazy.reject{|a, b| a.joint? b}.map{|a, b| a.union b}.first(steps)

connections = circuits.combination(2).sort_by{|a, b| a.distance b}.lazy.map{|a, b| a.union b }

connections.first(steps)
part1 = circuits.map(&:root).uniq.map(&:size).sort[-3..].reduce :*
puts "Part 1: #{part1}"

a, b = connections.compact.force[-1]
puts "Part 2: #{a.coords[0] * b.coords[0]}"
