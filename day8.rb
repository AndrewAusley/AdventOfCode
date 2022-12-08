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

  row_index = lines.size - 1
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
  visible_count
end


puts parse_trees
