# https://adventofcode.com/2022/day/8
# An index is 'visible' if the current number is a local maximum when approached from the
# North, South, East, or West of the array.

# Approach:
# We will tend to proceed naturally from the North and from the West. By keeping track of the current max in
# each direction, we can easily decide if a 'tree' is 'visible' from those directions in a single pass.
# Visible from South and East are trickier. We could just make a second pass in reverse order.
# Once we know a tree is visible from a single direction, we don't need to check the other directions, but
# we do need to make sure the record keeping mechanisms are updated.
# We need to keep track of the running max in each direction of travel. I'll keep track of the indices of
# the visible trees. I may try to store the max of each row and column during the first pass.
# I think this algorithm will be O(n) with a worst case of visiting every index twice.
# Because of record keeping, it will be O(n) in memory as well. I could probably use less memory, but you
# never know what part 2 is going to be.


def parse_trees(file = 'd8.txt')
  north_max = []
  west_max = []
  visible = Array.new(99) { Array.new(99) }
  north_visible = Array.new(99) { Array.new(99) }
  west_visible = Array.new(99) { Array.new(99) }
  lines = []
  visible_count = 0
  File.read(file).each_line.with_index do |line, row_index|
    line = line.strip
    # Keep lines in memory because reading a file backwards is annoying.
    lines.push(line.strip.split('').map { _1.to_i })

    line.each_char.with_index do |tree, col_index|
      tree = tree.to_i

      # Check if there is a new max from the north, map it as visible.
      north_max[col_index] = if north_max[col_index].nil? || tree > north_max[col_index]
                               visible_count += 1 unless visible[row_index][col_index] == true
        visible[row_index][col_index] = true
        north_visible[row_index][col_index] = true
        tree
      else
        north_max[col_index]
      end

      west_max[row_index] = if west_max[row_index].nil? || tree > west_max[row_index]
                              visible_count += 1 unless visible[row_index][col_index] == true
        visible[row_index][col_index] = true
        west_visible[row_index][col_index] = true
        tree
      else
        west_max[row_index]
      end
    end
  end

  south_max = []
  east_max = []
  south_visible = Array.new(99) { Array.new(99) }
  east_visible = Array.new(99) { Array.new(99) }

  row_index = lines.size - 1
  lines_copy = lines.clone
  # Iterate bottom to top, right to left
  until lines.empty?
    line = lines.pop
    length = line.size
    i = -1
    until i == -length
      tree = line[i]
      col_index = length + i
      south_max[col_index] = if south_max[col_index].nil? || tree > south_max[col_index]
                               visible_count += 1 unless visible[row_index][col_index] == true
        visible[row_index][col_index] = true
        north_visible[row_index][col_index] = true
        tree
      else
        south_max[col_index]
      end

      east_max[row_index] = if east_max[row_index].nil? || tree > east_max[row_index]
                              visible_count += 1 unless visible[row_index][col_index] == true
        visible[row_index][col_index] = true
        west_visible[row_index][col_index] = true
        tree
      else
        east_max[row_index]
      end
      i -= 1
    end
    row_index -= 1
  end
  puts visible_count
  puts find_treehouse_score lines_copy
end

def treehouse_score(input, row, col)
  limit = input.size - 1
  tree = input[row][col]

  north_count = 0
  north = []
  south = []
  east = []
  west = []
  i = 1
  while row - i >= 0
    north_count += 1

    if tree > input[row - i][col]
      i += 1
        else
          break
        end
  end

  south_count = 0
  i = 1
  while row + i <= limit
    south_count += 1
    if tree > input[row + i][col]
      i += 1
        else
          break
        end
  end

  east_count = 0
  i = 1
  while col + i <= limit
    east_count += 1
    if tree > input[row][col + i]
      i += 1
        else
          break
        end
  end

  west_count = 0
  i = 1
  while col - i >= 0
    west_count += 1
    if tree > input[row][col - i]
      i += 1
    else
      break
    end
  end

  puts "#{north_count}, #{south_count}, #{east_count}, #{west_count}"
  north_count * south_count * east_count * west_count
end

def find_treehouse_score(lines)
  scores = []
  (1..(lines.size - 2)).each do |row|
    (1..lines.size - 2).each do |col|
      tree_score = treehouse_score(lines, row, col)
        scores.push tree_score
        puts "#{tree_score}, #{row}, #{col}"
    end
  end
  scores.max
end

def read_file_to_array (file = 'd8.txt')
  input = []
  File.read(file).each_line do |line|
    # Keep lines in memory because reading a file backwards is annoying.
    input.push(line.strip.split('').map { _1.to_i })
  end
  input
end

def get_cartesian_array(input, row, col, direction = :north)
  row_limit = input.size - 1
  col_limit = input[0].size - 1

  if row.zero? || col.zero? || row == row_limit || col == col_limit
    return [-1]
  end

  case direction
  when :north
    input[0...row].map { _1[col] }.reverse
  when :south
    input[(row + 1)..row_limit].map { _1[col] }
  when :east
    input[row][(col + 1)..]
  when :west
    input[row][0...col].reverse
  else
    raise 'invalid direction!'
  end
end

def solution2part1(file = 'd8.txt')
  input = read_file_to_array file
  dirs = %i[north south east west]
  visible_count = 0
  (0...input.size).each do |row|
    (0...input.size).each do |col|
      dirs.each do |dir|
        if input[row][col] > get_cartesian_array(input, row, col, dir).max
          visible_count += 1
          break
        end
      end
    end
  end
  visible_count
end

def solution2part2(file = 'd8.txt')
  input = read_file_to_array file
  dirs = %i[north south east west]
  score_max = 0
  (1...input.size-1).each do |row|
    (1...input.size-1).each do |col|
      score = 1
      dirs.each do |dir|
        tree = input[row][col]
        arr = get_cartesian_array(input, row, col, dir)
        distance = arr.each_index.select { |i| arr[i] >= tree }.first
        score *= distance.nil? ? arr.size : distance + 1
      end
      score_max = score if score > score_max
    end
  end
  score_max
end

puts solution2part1
puts solution2part2
