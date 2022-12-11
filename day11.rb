# https://adventofcode.com/2022/day/11
# It seems like the main challenge here is to create a monkey class that handles all
# monkey operations and then a script that constructs the monkey objects.

# Each monkey needs:
# id - possibly not needed
# item magazine
# inspection operation
# test operation
# throw_to data structure
#
# inspect, operate, test, throw
$debug = false

class Monkey
  attr_accessor :id, :magazine, :inspection_array, :test, :throw_to, :inspection_count

  def initialize(id, mag, inspect, divisible, throw_to)
    @id = id
    # An array of integers
    @magazine = mag

    # a length 3 array [operand, operator, operand]
    @inspection_array = inspect

    # An int to test "divisible by"
    @test = divisible

    # An array of the next monkey to throw to.
    @throw_to = throw_to
    @inspection_count = 0
    @hash = {}
  end

  def do_round
    puts "Monkey #{@id}:" if $debug
    until @magazine.empty?
      inspected_item = inspect
      relieved_item = perform_relief inspected_item
      throw_to_monkey = test_item(relieved_item) ? @throw_to[0] : @throw_to[1]
      puts "    Item with worry level #{relieved_item} is thrown to monkey #{throw_to_monkey}." if $debug
      $monkeys[throw_to_monkey].magazine.push relieved_item
    end
    puts "" if $debug
  end

  # TODO handle empty magazine
  def inspect
    @inspection_count += 1
    item = @magazine.shift
    puts "  Monkey #{@id} inspects an item with a worry level of #{item}." if $debug
    perform_inspection(item)
  end

  def perform_inspection(item)
    item = item
    worried_item = if @inspection_array[0] == 'old' && @inspection_array[2] == 'old'
      item.public_send @inspection_array[1], item
    else
      item.public_send @inspection_array[1], @inspection_array[2].to_i
    end
    puts "    Worry level is increased from #{item} to #{worried_item}" if $debug
    worried_item
  end

  def perform_relief(item)
    new = item % $mod
    puts "    Monkey gets bored with item. Worry level is divided by 3 to #{new}." if $debug
    new
  end

  def test_item(item)
    tested = (item % @test).zero?
    puts "    Current worry level #{tested ? 'is' : 'is not'} divisible by #{@test}." if $debug
    tested
  end
end

def parse_monkeys(file = 'd11.txt')
  File.read(file).each_line.each_slice(7) do |lines|
    $monkeys.push parse_monkey(lines)
  end
  $mod = $monkeys.map(&:test).inject(:*)

  (1..10000).each do |round|
    $round = round
    $monkeys.each(&:do_round)
  end
  $monkeys.map(&:inspection_count).max(2).inject(:*)
end

def parse_monkey(lines)
  id  = lines[0].tr(":\n", '').split(' ').last.to_i
  mag = lines[1].strip.split(': ').last.split(', ').map { _1.to_i }
  inspect = lines[2].strip.split(' = ').last.split(' ')
  divisible = lines[3].strip.split(' ').last.to_i
  true_throw_monkey = lines[4].strip.split(' ').last.to_i
  false_throw_monkey = lines[5].strip.split(' ').last.to_i

  Monkey.new(id, mag, inspect, divisible, [true_throw_monkey, false_throw_monkey])
end

$monkeys = []
$round = 0
puts parse_monkeys
