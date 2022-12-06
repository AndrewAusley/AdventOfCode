# https://adventofcode.com/2022/day/6
# Start of packet indicator: 4 unique characters
# A sliding window of size 4 is needed and check if the window has all uniq characters
# Read 4 characters into a buffer, shift one off, push one on, keep a counter

def find_packet_indicator(window_size, file = 'd6.txt')
  buff = []
  count = 0
  File.read(file).each_char do |char|
    count += 1
    buff.push char
    next unless count > window_size

    buff.shift
    return count if (buff & buff) == buff
  end
  raise 'No package indicatior found!'
end
# Part 1
puts find_packet_indicator 4

# Part 2
puts find_packet_indicator 14
