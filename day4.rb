# https://adventofcode.com/2022/day/4
# Data form: "57-93,9-57\n"
# Part 1: How many ranges are redundant?
# Approach: Find the width of the two ranges. Determine if the narrow min is larger than the wider min and
# the narrower max is smaller than the wider max.

# Part 2: how many ranges overlap?
# Approach: Check if either number of one range is within the other range.

def evaluate_groups(part, file = 'd4.txt')
  File.read(file).each_line.sum do |line|
    # Make line into two arrays of two integers each
    first, second = line.strip.split(',').map { _1.split('-').map(&:to_i) }

    case part
    when 1
      # Sort the ranges so the wider is first, narrower second.
      # Check if the narrow range is totally within or equal to the wide range, use truthy value that equates to tally
      range_redundancy?(sort_by_range_desc(first, second))
    when 2
      # Sort the ranges so the wider is first, narrower second.
      # Check if either endpoint of the narrower is within the wider.
      range_overlap? sort_by_range_desc(first, second)
    else
      raise 'Invalid Part!'
    end
  end
end

# This function returns true or false in the form of 1 or 0.
def range_redundancy?(ranges)
  wide = ranges[0]
  narrow = ranges[1]
  narrow[0] < wide[0] || narrow[1] > wide[1] ? 0 : 1
end

def range_overlap?(ranges)
  wide = ranges[0]
  narrow = ranges[1]
  num_in_range?(wide, narrow[0]) || num_in_range?(wide, narrow[1]) ? 1 : 0
end

def num_in_range?(range, num)
  num >= range[0] && num <= range[1]
end

def sort_by_range_desc(first, second)
  first_range = first[1] - first[0]
  second_range = second[1] - second[0]

  if first_range > second_range
    [first, second]
  else
    [second, first]
  end
end

puts evaluate_groups 1
puts evaluate_groups 2

