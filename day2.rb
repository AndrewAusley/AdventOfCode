# There are points associate for each throw_type {X, Y, Z}
# There are points for each outcome {win, lose, draw}
# There points for each round are throw type + outcome.
# Total points are the sum of all the rounds.

# Read each round, determine the outcome, get the outcome-based points, add the thrown-based points.
# X = Rock, Y = Paper, Z = Scissors
# A = Rock, B = Paper, C = Scissors

def calculate_total_score_of_two_throws(file = 'd2.txt')
  my_score = File.read(file).each_line.sum do
    elf_throw, my_throw = _1.split
    paper_rock_scissors_score(elf_throw, my_throw)
  end
  puts my_score
end

def paper_rock_scissors_score(elf_throw, my_throw)
  me = decode_throw(my_throw)
  elf = decode_throw(elf_throw)
  outcome = get_outcome(elf, me)

  get_outcome_score(outcome) + get_throw_score(me)
end

def get_outcome_score(outcome)
  outcome_score = { win: 6, draw: 3, lose: 0 }
  outcome_score.fetch(outcome)
end

def get_outcome(elf, me)
  win_outcomes = { rock: :scissors, paper: :rock, scissors: :paper }
  if me == elf
    :draw
  elsif elf == win_outcomes[me]
    :win
  else
    :lose
  end
end

def get_throw_score(throw)
  throw_score = { rock: 1, paper: 2, scissors: 3 }
  throw_score.fetch(throw)
end

def decode_throw(throw)
  throws = { 'X' => :rock, 'Y' => :paper, 'Z' => :scissors, 'A' => :rock, 'B' => :paper, 'C' => :scissors }
  throws.fetch(throw)
end

# I'm taking a different approach. I'm letting each throw have a numeric value 0-2 and representing the outcome
# as the result of Throw1 - Throw2. If I choose the values carefully, I can get the desired throw based on the
# outcome from modulo addition. Everything else is a mapping problem.
def part2(file = 'd2.txt')
  throws = %i[rock paper scissors]
  outcomes = {'X' => :lose, 'Y' => :draw, 'Z' => :win }
  throw_index_map = { 'A' => 0, 'B' => 1, 'C' => 2 }

  # Based on the results of My_throw_index minus your_throw_index mod 3
  outcome_value_map = { 'X' => -1, 'Y' => 0, 'Z' => 1 }

  my_score = File.read(file).each_line.sum do
    elf_throw, desired_outcome = _1.split
    elf_index = throw_index_map[elf_throw]
    outcome_value = outcome_value_map[desired_outcome]
    outcome = outcomes[desired_outcome]
    my_throw_index = (elf_index + outcome_value) % 3
    my_throw = throws[my_throw_index]
    get_outcome_score(outcome) + get_throw_score(my_throw)
  end
  puts my_score
end

calculate_total_score_of_two_throws
part2
