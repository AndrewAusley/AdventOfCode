# O(n) runtime: Each line is visited once
# O(1) memory: Only the current line, current sum, and top three inventories are needed.
def simple_and_verbose(file = 'd1.txt')
  elf_max = [0, 0, 0]
  elf_sum = 0
  File.read(file).each_line do |line|
    elf_sum += line.to_i
    if line == "\n"
      if elf_sum > elf_max[0]
        elf_max[2] = elf_max[1]
        elf_max[1] = elf_max[0]
        elf_max[0] = elf_sum
      elsif elf_sum > elf_max[1]
        elf_max[2] = elf_max[1]
        elf_max[1] = elf_sum
      elsif elf_sum > elf_max[2]
        elf_max[2] = elf_sum
      end
      elf_sum = 0
    end
  end

  puts "simple_and_verbose #{elf_max.sum}"
end

# Similar to simple_and_verbose, but new candidate inventories are array concatenated to take advantage of
# the enum max function. Possibly less optimal depending on how Ruby handles array concatenation.
# Still O(n), O(1)
def array_concat(file = 'd1.txt')
  elf_max = [0, 0, 0]
  elf_sum = 0
  File.read(file).each_line do |line|
    elf_sum += line.to_i
    if line == "\n"
      elf_max = (elf_max+[elf_sum]).max(3)
      elf_sum = 0
    end
  end

  puts "array_concat #{elf_max.sum}"
end

# Make use of all the fancy Ruby functions to reduce lines of code.
# I think it is still O(n) runtime but it is O(e) memory as elf_calories grows according to the number of elves.
def concise(file = 'd1.txt')
  # Split the file by empty lines (back-to-back newlines). Output: "10\n52\n61\n"
  # Split the inventory of each elf by newline, converting each to integer, and sum.
  elf_calories = File.read(file).split("\n\n").map { |elf| elf.split("\n").map(&:to_i).sum }

  # Take the top 3 of the elf inventories, sum them, convert to string for output.
  puts "concise #{elf_calories.max(3).sum}"
end

simple_and_verbose
array_concat
concise
