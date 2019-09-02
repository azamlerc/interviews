# Four fours is a mathematical puzzle. The goal is to find a mathematical expression for every whole number from 1 to 100, using only common mathematical symbols and the number four four times.

# Problem: https://en.wikipedia.org/wiki/Four_fours
# Playground: http://www.zamler-carhart.com/andrew/fourfours/

# In this case, we will start with the initial values 4, .4, √4 and 4! and combine them using the operations addition, subtraction, multiplication and division.

defmodule Fours do 
  def combine(setA, setB) do 
    (for a <- setA, b <- setB,
      do: [a+b, a-b, b-a, a*b]
        ++ if a != 0, do: [b/a], else: []
        ++ if b != 0, do: [a/b], else: [])
    |> Enum.reduce([], fn(x, accum) -> accum ++ x end) 
    |> Enum.uniq 
    |> Enum.map(fn(x) -> Float.round(x/1, 6) end) 
  end
end

fours1 = [4, :math.sqrt(4), 4*3*2*1, 0.4]
fours2 = Fours.combine(fours1, fours1)
fours3 = Fours.combine(fours1, fours2)
fours4 = Fours.combine(fours1, fours3)
      ++ Fours.combine(fours2, fours2)

found = Enum.filter(1..100, fn(i) -> Enum.member?(fours4, i/1) end)
missing = Enum.filter(1..100, fn(i) -> !Enum.member?(fours4, i/1) end)

IO.puts "found:"
IO.puts Enum.map(found, fn(i) -> "#{i} " end)

IO.puts "\nmissing:"
IO.puts Enum.map(missing, fn(i) -> "#{i} " end)

if length(missing -- [73,77,81,87,93,99]) == 0, do: IO.puts "\nSuccess!"
