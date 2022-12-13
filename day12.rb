# https://adventofcode.com/2022/day/12
# It looks like we are traversing a grid / graph. We can do a breadth-first-search and keep
# track of the number of steps it takes to reach each square. In a hashmap, we can store
# the minimum number of steps it takes to reach each coordinate. If we reach a coordinate
# that has already been visited and we haven't reached used fewer steps, that is an ending
# condition. We can advance to letters valued at one-higher or any lower letter.

$debug = true
def parse_input(file = 'd12.txt')
  $map = []
  start = []
  File.read(file).each_line.with_index do |line, index|
    $map[index] = line.strip.split('')
    if start.empty?
      col = $map[index].find_index('S')
      start = [index, col] unless col.nil?
    end
  end

  visited = {}
  cost = {}

  # seen = [cost, [x,y]]
  seen = [[0, start]]

  until seen.empty?
    node_cost, visiting = seen.shift
    if get_letter(visiting) == 'E'
      puts "Final cost: #{node_cost}"
      return
    end

    next if visited.include?("#{visiting[0]},#{visiting[1]}")
    puts "#{visiting[0]}, #{visiting[1]} Letter: #{get_letter visiting} Cost: #{node_cost}" if $debug
    visited.store("#{visiting[0]},#{visiting[1]}", true)
    cost.store("#{visiting[0]},#{visiting[1]}", node_cost)
    get_neighbors(visiting).each do |node|
      total = node_cost + 1
      seen.push([total, node])
    end
    # Sort not needed when cost is fixed
    # seen.sort_by { |indv_cost, _node| indv_cost }
  end

end

def get_neighbors(node)
  # Start with the 4 cardinal directions as options
  initial = [[node[0] + 1, node[1]], [node[0] - 1, node[1]], [node[0], node[1] + 1], [node[0], node[1] - 1]]

  # Ensure each direction is within the bounds
  inbounds = initial.filter do |x, y|
    x >= 0 && y >= 0 && x < $map.size && y < $map[0].size
  end

  # Filter out anything that isn't the same letter, next letter, or if letter is 'z', the end
  inbounds.filter do |e|
    # Start / Stop conditions
    if (get_letter(node) == 'z' && get_letter(e) == 'E') || (get_letter(node) == 'S' && get_letter(e) == 'a')
      true
    else
      # If the next step is NOT 'E', the next letter can only be 1 higher or less.
      get_letter(e) != 'E' && ((get_letter(e).ord - get_letter(node).ord) <= 1)
    end
  end
end

def get_letter(coord)
  $map[coord[0]][coord[1]]
end

parse_input
