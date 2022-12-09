# https://adventofcode.com/2022/day/9
# Each instruction is going to updated an H coordinate by += 1
# Each incrementation will lead zero, one, or both coordinates of T being updated +=1
# Initially, we want the count of unique coordinates the T has visited. A hash will do this well.

$visited = { '0,0' => true }
$debug = false
$rope = Array.new(10).map { [0, 0] }
def parse_moves(file = 'd9.txt')
  File.read(file).each_line do |line|
    dir, count = line.strip.split(' ')
    move($rope, dir, count.to_i)
  end
  $visited.size
end

def move(rope, dir, count)
  index = 0
  until count.zero?
    case dir
    when 'R'
      rope[index][0] += 1
    when 'L'
      rope[index][0] -= 1
    when 'D'
      rope[index][1] -= 1
    when 'U'
      rope[index][1] += 1
    else
      raise 'Invalid direction!'
    end
    puts "Head moved to #{rope[0][0]}, #{rope[0][1]}" if $debug
    move_t(rope, index)
    count -= 1
  end
end

def move_t(rope, index)
  puts "Moving knot #{index + 1}" if $debug
  x_dist = rope[index][0] - rope[index + 1][0]
  y_dist = rope[index][1] - rope[index + 1][1]
  move = x_dist.abs == 2 || y_dist.abs == 2
  return unless move

  if x_dist.negative?
    rope[index + 1][0] -= 1
  elsif x_dist.positive?
    rope[index + 1][0] += 1
  end

  if y_dist.negative?
    rope[index + 1][1] -= 1
  elsif y_dist.positive?
    rope[index + 1][1] += 1
  end
  $visited.store("#{rope[index + 1][0]},#{rope[index + 1][1]}", true) if (index + 1) == ($rope.size - 1)
  puts "Knot #{index + 1} moved to #{rope[index + 1][0]},#{rope[index + 1][1]} | Visited: #{$visited.size}" if $debug
  move_t(rope, index + 1) if index < $rope.size - 2
end

puts parse_moves
