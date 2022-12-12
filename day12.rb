# https://adventofcode.com/2022/day/12
# It looks like we are traversing a grid / graph. We can do a breadth-first-search and keep
# track of the number of steps it takes to reach each square. In a hashmap, we can store
# the minimum number of steps it takes to reach each coordinate. If we reach a coordinate
# that has already been visited and we haven't reached used fewer steps, that is an ending
# condition. Each valid adjacent square can be scored as the score of the the lowest-scored
# adjacent move plus one.


# Parse and progress is possible, but for simplicity, stick to parse and process.
def parse_input(file = 'd12.txt')
  $map = []
  $score = { '0,0' => 0 }
  $path = { '0,0' => nil }
  File.read(file).each_line.with_index do |line, index|
    $map[index] = line.strip.split('')
  end
  # A dirty, lazy hack
  $map[0][0] = '`'
  walk_map [0, 0]
end

# From is not strictly needed, but it will let us keep track of the path taken.
def walk_map(coord, queue = [], from = [0, 0])
  unless coord == [0, 0]
    from_score = get_score from
    to_score = get_score coord
    return unless to_score.nil? || (to_score < from_score)

    set_score coord, from_score + 1
    set_path coord, from
    if $map[coord[0]][coord[1]] == 'E'
      puts "#{get_score coord}"
      return
    end
  end

  queue += get_valid_moves(coord)
  until queue.empty?
    to, from = queue.shift
    walk_map(to, queue, from)
  end
  test = 1
end

def get_valid_moves(coord)
  initial = [[coord[0] + 1, coord[1]], [coord[0] - 1, coord[1]], [coord[0], coord[1] + 1], [coord[0], coord[1] - 1]]
  candidates = initial.filter do |x, y|
    x >= 0 && y >= 0 && x < $map.size && y < $map[0].size && (x != coord[0] || y != coord[1])
  end

  # Filter out invalid moves and map them to their from coord for BFS
  candidates.filter { valid_move?([_1, _2], coord) }.map { |to| [to, coord] }
end

def valid_move?(to, from)
  # If the next letter isn't one different or the same, not valid
  return false unless ($map[to[0]][to[1]].ord - $map[from[0]][from[1]].ord).abs <= 1 || ($map[to[0]][to[1]] == 'E' && $map[from[0]][from[1]] == 'z')

  # If the letters are valid and hasn't been visited, valid
  to_score = get_score to
  return true if to_score.nil?

  # If the letters are valid, it has been visited, but this is a shorter path, valid
  from_score = get_score from
  (to_score - (from_score + 1)).positive?
end

def get_score(coord)
  $score.fetch("#{coord[0]},#{coord[1]}", nil)
end

def set_score(coord, score)
  $score.store("#{coord[0]},#{coord[1]}", score)
end

def set_path(coord, from_coord)
  $path.store("#{coord[0]},#{coord[1]}", "#{from_coord[0]},#{from_coord[1]}")
end

parse_input
