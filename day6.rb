# https://adventofcode.com/2022/day/6
# Start of packet indicator: 4 unique characters
# A sliding window of size 4 is needed and check if the window has all uniq characters
# Read 4 characters into a buffer, shift one off, push one on, keep a counter

def find_packet_indicator(window_size, file = 'd6.txt')
  count = 0
  File.read(file).each_char.each_cons(window_size) do |buffer|
    count += 1
    return count + window_size - 1 if (buffer & buffer).size == buffer.size
  end
  raise 'No package indicatior found!'
end
# Part 1
puts find_packet_indicator 4

# Part 2
puts find_packet_indicator 14
