# https://adventofcode.com/2022/day/5
# Manually input the state into an array.
# Parse the instructions to pop crates off one array and push them onto another array.
def init_state
  $state = [
    [],
    %w[Z P M H R],
    %w[P C J B],
    %w[S N H G L C D],
    %w[F T M D Q S R L],
    %w[F S P Q B T Z M],
    %w[T F S Z B G],
    %w[N R V],
    %w[P G L T D V C M],
    %w[W Q N J F M L]
  ]
end

def parse_crates(part = 1, file = 'd5.txt')
  init_state

  count = 1
  File.read(file).each_line do |line|
    # Skip the first 10 lines since I manually entered that data.
    if count < 11
      count += 1
      next
    end

    # Parse the line into the 3 useful pieces of info
    _move, num_to_move, _from, from_stack, _to, to_stack = line.strip.split(' ')

    case part
    when 1
      move_crates_singly(num_to_move.to_i, from_stack.to_i, to_stack.to_i)
    when 2
      move_crates_by_stack(num_to_move.to_i, from_stack.to_i, to_stack.to_i)
    else
      raise 'Invalid Part!'
    end
  end
  get_top_crates
end

def get_top_crates
  stack = 1
  list = ""
  while stack < $state.size
    list.concat($state[stack][-1])
    stack += 1
  end
  list
end

def move_crates_by_stack(num_to_move, from_stack, to_stack)
  $state[to_stack] += $state[from_stack].pop(num_to_move)
end

def move_crates_singly(num_to_move, from_stack, to_stack)
  moves = 0
  while moves < num_to_move
    raise 'No more crates on stack!' if $state[from_stack].empty?

    $state[to_stack].push($state[from_stack].pop)
    moves += 1
  end
end

puts parse_crates 1
puts parse_crates 2
