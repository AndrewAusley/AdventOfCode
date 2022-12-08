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
  i = 1
  while row - i >= 0
    if tree > input[row - i][col]
      north_count += 1
      i += 1
    else
      north_count += 1
      break
    end
  end
  return 0 unless north_count.positive?

  south_count = 0
  i = 1
  while row + i <= limit
    if tree > input[row + i][col]
      south_count += 1
      i += 1
    else
      south_count += 1
      break
    end
  end
  return 0 unless south_count.positive?

  east_count = 0
  i = 1
  while col + i <= limit
    if tree > input[row][col + 1]
      east_count += 1
      i += 1
    else
      east_count += 1
      break
    end
  end
  return 0 unless east_count.positive?

  west_count = 0
  i = 1
  while col - i >= 0
    if tree > input[row][col - i]
      west_count += 1
      i += 1
    else
      west_count += 1
      break
    end
  end
  return 0 unless west_count.positive?

  puts "#{north_count}, #{south_count}, #{east_count}, #{west_count}"
  product = north_count* south_count*east_count*west_count
  puts product
  product
end


def find_treehouse_score(lines)
  scores = []
  (1..(lines.size - 2)).each do |row|
    (1..lines.size - 2).each do |col|
      tree_score = treehouse_score(lines, row, col)
      if tree_score.positive?
        scores.push tree_score
        puts "#{tree_score}, #{row}, #{col}"
      end
    end
  end
  scores.max
end

parse_trees('test.txt')
