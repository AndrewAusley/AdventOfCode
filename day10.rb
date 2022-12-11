# https://adventofcode.com/2022/day/10

# As usual, start with something straight forward. I want this code to be readable and clear
# above all. I'll run an array that keeps track of the value at a given cycle and then use that
# to generate the signal at the important cycles.

$debug = false
$signal_cycles = [20, 60, 100, 140, 180, 220]
$register = [0]
$screen = Array.new(6) {Array.new(40)}

def parse_instructions(file = 'd10.txt')
  register = cycle = 1
  File.read(file).each_line do |line|
    cycle, register = update_register(cycle, register, line)
  end
  calculate_signal
end

def update_register(cycle, register, line)
  puts "#{line.strip} Cycle #{cycle} Register #{register}" if $debug
  inst = line.strip.split(' ')
  $register[cycle] = register
  get_light_or_dark(cycle, register)
  if inst.size == 2
    cycle += 1
    $register.push register
    puts "#{line.strip} Cycle #{cycle} Register #{register}" if $debug
    get_light_or_dark(cycle, register)
    register += inst[1].to_i
  end
  cycle += 1
  [cycle, register]
end

def get_pixel_from_cycle(cycle)
  # zero index cycle
  cycle -= 1
  row = cycle.div(40)
  [row, cycle - row * 40]
end

def get_light_or_dark(cycle, register)
  row, col = get_pixel_from_cycle cycle

  # Check if current pixel is +-1 from register
  pixel = (col - register).abs <= 1 ? '#' : '.'
  puts pixel if $debug
  $screen[row][col] = pixel
  pixel
end

def print_screen
  $screen.each do |row|
    puts "#{row.join('')}\n"
  end
end

def calculate_signal
  $signal_cycles.each.sum do |cycle|
    puts "Signal #{cycle} | Register at Signal #{$register[cycle]}" if $debug
    cycle * $register[cycle]
  end
end



puts parse_instructions
print_screen
