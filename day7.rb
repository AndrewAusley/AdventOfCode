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
# Create rollup of sizes (TODO: if none of the children sizes are nil?)
# If ls
# Create any non-existent nodes as children of current node pointer
# TODO: Are directories uniquely named?
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

class Graph
  attr_accessor :nodes

  def initialize(node = nil)
    @nodes = {}
    @nodes.store(node.name, node) unless node.nil?
  end

  def add_node(node)
    @nodes.store node.name, node
  end
end

def parse_input(file = 'd7.txt')
  $root = Node.new(nil, '/', :dir)
  current_dir = $root

  input = File.read file
  input.each_line do |line|
    vars = line.strip.split ' '
    if vars[0] == '$'
      current_dir = parse_command(vars, current_dir)
    else
      parse_node(vars, current_dir)
    end
  end
end

def get_size(node)
  size = 0
  node.children.each do |_name, child|
    return nil if child.size.nil?

    size += child.size
  end
end

def parse_command(vars, current_dir)
  return current_dir if vars[1] == 'ls'

  case vars[2]
  when '/'
    # Jump to the beginning
    $root
  when '..'
    # Try to calculate size, jump to parent
    current_dir.size = get_size(current_dir)
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


parse_input
