# https://adventofcode.com/2022/day/12
# It looks like we are traversing a grid / graph. We can do a breadth-first-search and keep
# track of the number of steps it takes to reach each square. In a hashmap, we can store
# the minimum number of steps it takes to reach each coordinate. If we reach a coordinate
# that has already been visited and we haven't reached used fewer steps, that is an ending
# condition. We can advance to letters valued at one-higher or any lower letter.

$debug = false
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
  route_costs = []
  # seen = [cost, [x,y]]
  seen = [[0, start]]

  until seen.empty?
    node_cost, visiting = seen.shift
    if get_letter(visiting) == 'E'
      route_costs.push node_cost
    end
    existing_cost = cost.fetch("#{visiting[0]},#{visiting[1]}", -1)
    next if (existing_cost != -1) && existing_cost <= node_cost
    puts "#{visiting[0]}, #{visiting[1]} Letter: #{get_letter visiting} Cost: #{node_cost}" if $debug
    visited.store("#{visiting[0]},#{visiting[1]}", true)
    cost.store("#{visiting[0]},#{visiting[1]}", node_cost)
    get_neighbors(visiting).each do |node|
      total = get_letter(node) == 'a' ? 0 : node_cost + 1
      seen.push([total, node])
    end
    # Sort not needed when cost is fixed
    # seen.sort_by { |indv_cost, _node| indv_cost }
  end

  puts "Shortest path from 'a' is #{route_costs.min}"
end

def get_neighbors(node)
  # Start with the 4 cardinal directions as options
  initial = [[node[0] + 1, node[1]], [node[0] - 1, node[1]], [node[0], node[1] + 1], [node[0], node[1] - 1]]

  # Ensure each direction is within the bounds
  inbounds = initial.filter do |x, y|
    x >= 0 && y >= 0 && x < $map.size && y < $map[0].size
  end

  # Filter out anything that isn't height+1 or less
  inbounds.filter { |e| (get_height(e) - get_height(node)) <= 1 }
end

def get_height(node)
  case get_letter(node)
  when 'E'
    'z'.ord
  when 'S'
    'a'.ord
  else
    get_letter(node).ord
  end
end

def get_letter(coord)
  $map[coord[0]][coord[1]]
end

parse_input
