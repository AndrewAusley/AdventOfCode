# Lines are always even length (equal items per compartment)
# Uppercase, lowercase letters input
# Determine letters of the same case that appear in the first half AND second half of the line
# Assign numeric priority for a - Z => 1 - 52

# This function takes an even-length string of letters.
# I'm going to assume the inputs are sanitized.
def find_duplicate_items(line)
  book = {}
  line = line.strip
  line[0..(line.length / 2 - 1)].split('').each do |letter|
    book.store(letter, true)
  end

  line[(line.length / 2)..].split('').map do |letter|
    next unless book.include?(letter)

    book.delete(letter)
    letter
  end.compact.pop
end

# This function takes a letter to be scored.
def score_item(item)
  if item.ord >= 97
    item.ord - 96
  else
    item.ord - 38
  end
end

def find_intersection(three_lines)
  book = {}
  three_lines[0].split('').each do |letter|
    book.store(letter, true)
  end

  next_book = {}
  three_lines[1].split('').each do |letter|
    next_book.store(letter, true) if book.include? letter
  end

  three_lines[2].split('').each do |letter|
    return letter if next_book.include? letter
  end
end

def evaluate_compartments(file = 'd3.txt')
  File.read(file).each_line.sum do |line|
    item = find_duplicate_items(line)
    score_item(item)
  end
end

def evaluate_groups(file = 'd3.txt')
  line_count = 0
  three_lines = []
  File.read(file).each_line.sum do |line|
    # Build up a group of elves (3 lines)
    three_lines[line_count % 3] = line.strip
    line_count += 1

    # Once the group is formed, find the intersection and score it.
    if line_count % 3 == 0
      item = find_intersection(three_lines)
      three_lines = []
      score_item(item)
    else
      0
    end
  end
end

puts evaluate_compartments
puts evaluate_groups
