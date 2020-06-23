# Four fours is a mathematical puzzle. The goal is to find a mathematical
# expression for every whole number from 1 to 100, using only common
# mathematical symbols and the number four four times.
#
# Problem: https://en.wikipedia.org/wiki/Four_fours
# Playground: https://andrewzc.net/fourfours/
#
# In this case, we will start with the initial values 4, .4, √4 and 4!
# and combine them using the operations addition, subtraction,
# multiplication and division.

require 'set'

def combine(fours, countA, countB)
  newSet = fours[countA + countB]
  fours[countA].each do |a|
    fours[countB].each do |b|
      newSet.add(round(a + b))
      newSet.add(round(a - b))
      newSet.add(round(b - a)) if a != b
      newSet.add(round(a * b))
      newSet.add(round(a / b)) if b != 0
      newSet.add(round(b / a)) if a != 0 && a != b
    end
  end
end

# Returns a list of sets of numbers that can be generated with
# zero, one, two, three, or four of the number four.
def four_fours
  fours = [
    Set[],
    Set[4, Math.sqrt(4), 4*3*2*1, 0.4],
    Set[],
    Set[],
    Set[]
  ]

  # your solution here
  # calcualte fours[2], fours[3] and fours[4]
   combine(fours, 1, 1);
   combine(fours, 1, 2);
   combine(fours, 1, 3);
   combine(fours, 2, 2);

  return fours
end

# rounds the value to 6 decimal places
def round(val)
  return val.round(6)
end

def print_fours(fours)
  for i in 1..3 do
    array = fours[i].to_a.sort
    puts "#{i} fours: #{array}\n\n"
  end

  found = []
  missing = []
  for i in 1..100 do
    if fours[4].include?(i.to_f)
      found.push(i)
    elsif
      missing.push(i)
    end
  end

  puts "4 fours: #{found}\n\n"
  puts "missing: #{missing}\n\n"

  if missing == [73,77,81,87,93,99]
    puts "Success!"
  end
end

fours = four_fours
print_fours(fours)