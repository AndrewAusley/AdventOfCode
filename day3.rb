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
  if item.ord >= 'a'.ord
    item.ord - ('a'.ord - 1)
  else
    item.ord - ('A'.ord - 26 - 1)
  end
end

def find_intersection(three_lines)
  (three_lines[0].strip.chars & three_lines[1].strip.chars & three_lines[2].strip.chars)[0]
end

def evaluate_compartments(file = 'd3.txt')
  File.read(file).each_line.sum do |line|
    item = find_duplicate_items(line)
    score_item(item)
  end
end

def evaluate_groups(file = 'd3.txt')
  File.read(file).lines.each_slice(3).sum do |lines|
    item = find_intersection(lines)
    score_item(item)
  end
end

puts evaluate_compartments
puts evaluate_groups
