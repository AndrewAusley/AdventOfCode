# There are points associate for each throw_type {X, Y, Z}
# There are points for each outcome {win, lose, draw}
# There points for each round are throw type + outcome.
# Total points are the sum of all the rounds.

# Read each round, determine the outcome, get the outcome-based points, add the thrown-based points.
# X = Rock, Y = Paper, Z = Scissors
# A = Rock, B = Paper, C = Scissors

[:rock, :paper, :scissors]

def calculate_total_score_of_two_throws(file = 'd2.txt')
  my_score = 0
  File.read(file).each_line.map do
    elf_throw, my_throw = _1.split
    my_score += paper_rock_scissors_score(elf_throw, my_throw)
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
  raise 'Invalid throw!' unless outcome_score.include?(outcome)

  outcome_score[outcome]
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
  raise 'Invalid throw!' unless throw_score.include?(throw)

  throw_score[throw]
end

def decode_throw(throw)
  throws = { 'X' => :rock, 'Y' => :paper, 'Z' => :scissors, 'A' => :rock, 'B' => :paper, 'C' => :scissors }
  raise 'Invalid throw!' unless throws.include?(throw)

  throws[throw]
end

calculate_total_score_of_two_throws
