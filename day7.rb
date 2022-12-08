# https://adventofcode.com/2022/day/7
# Provided a directory structure and commands that navigate it and print files with their sizes,
# we need to build a graph that models the directory by parsing the input and keep track of the
# directory sizes by some sort of depth-first-search.

# We are going to need to implement a graph.
# Instructions: cd x, cd .., cd /, ls
# If cd :name
# Check if node exists and create it setting current node pointer as parent and updating current node pointer
# If cd /
# Node will exist, switch current_node pointer to that from Graph hash
# If cd ..
# Switch current node pointer to parent of current node pointer
# Create rollup of sizes (if none of the children sizes are nil?) Hindsight: handle directory sizes at the end
# If ls
# Create any non-existent nodes as children of current node pointer
# TODO: Are directories uniquely named?
# Hindsight: Doesn't matter since I didn't use a graph with an array/hash of all nodes
# Hindsight #2: IT SUPER DUPER DOES MATTER IF YOU ARE STORING THEIR SIZES IN A HASHMAP USING NAMES AS THE KEY.
#
class Node
  attr_accessor :parent, :name, :children, :type, :size

  def initialize(parent, name, type, size = nil)
    @parent = parent
    @name = name
    @type = type
    @size = size
    @children = {}
  end

  def add_child(node)
    @children.store node.name, node
    node
  end

  def get_child(name)
    @children.fetch(name, nil)
  end
end

def parse_input(file = 'd7.txt')
  $root = Node.new(nil, '/', :dir)
  current_dir = $root

  File.read(file).each_line do |line|
    vars = line.strip.split ' '
    if vars[0] == '$'
      current_dir = parse_command(vars, current_dir)
    else
      parse_node(vars, current_dir)
    end
  end
end

def parse_command(vars, current_dir)
  return current_dir if vars[1] == 'ls'

  case vars[2]
  when '/'
    # Jump to the beginning
    $root
  when '..'
    # Back up to the parent node
    current_dir.parent.nil? ? current_dir : current_dir.parent
  else
    # See if the child node exists, else create it and link it.
    node = current_dir.get_child(vars[2])
    node.nil? ? current_dir.add_child(Node.new(current_dir, vars[2], :dir)) : node
  end
end

# Parse a non-command line
def parse_node(vars, current_dir)
  node = current_dir.get_child(vars[1])
  return node unless node.nil?

  if vars[0] == 'dir'
    current_dir.add_child Node.new(current_dir, vars[1], :dir)
  else
    size = vars[0].to_i
    current_dir.add_child Node.new(current_dir, vars[1], :file, size)
  end
end

def set_dir_sizes(node = $root, sum = 0)
  # Directories will not have a size yet.
  if node.size.nil?
    node.size = node.children.map.sum do |_name, child|
      sum = set_dir_sizes(child, sum) if child.type == :dir

      child.size
    end
    # Part 1: Sum the sizes of all directories smaller than 100k.
    if node.size <= 100000
      sum += node.size
    end
    $dir_space << node.size
  end
  sum
end

def print_children(node)
  puts "Printing children for #{node.name} Size: #{node.size}"
  node.children.each do |key, child|
    puts "    Type: #{child.type} Size: #{child.size} Name: #{key}"
  end
end

$dir_space = []
parse_input
puts "The sum of directories smaller than 100,000 is: #{set_dir_sizes}"
puts 'The total system memory is 70,000,000'
puts "The total space used on our system is #{$root.size}"
puts 'We need at least 30,000,000 free memory'
free_space = 70000000 - $root.size
puts "We have #{free_space} free space."
needed_space = 30000000 - free_space
puts "We need to free up at least #{needed_space}"

puts "There is a folder to delete that will free up #{$dir_space.sort.find { |v| v > needed_space}}"
