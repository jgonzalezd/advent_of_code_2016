require 'byebug'

# --- Day 3: Squares With Three Sides ---
#
# Now that you can think clearly, you move deeper into the labyrinth of hallways and office furniture that makes up this part of Easter Bunny HQ. This must be a graphic design department; the walls are covered in specifications for triangles.
#
# Or are they?
#
# The design document gives the side lengths of each triangle it describes, but... 5 10 25? Some of these aren't triangles. You can't help but mark the impossible ones.
#
# In a valid triangle, the sum of any two sides must be larger than the remaining side. For example, the "triangle" given above is impossible, because 5 + 10 is not larger than 25.
#
block = Proc.new do |dimensions|
  dimensions = dimensions.map(&:to_i).sort
  sum =  dimensions.first(2).inject(:+)
  sum > dimensions.last
end


File.open('input.txt') do |f|
  possibles = f.map do |line|
    dimensions = line.strip.split(" ")
    block.call(dimensions)
  end
  p "Possible triangles problem 1:  #{possibles.count(true)}"
end

# --- Part Two ---
#
# Now that you've helpfully marked up their design documents, it occurs to you that triangles are specified in groups of three vertically. Each set of three numbers in a column specifies a triangle. Rows are unrelated.
#
# For example, given the following specification, numbers with the same hundreds digit would be part of the same triangle:
#
# 101 301 501
# 102 302 502
# 103 303 503
# 201 401 601
# 202 402 602
# 203 403 603
# In your puzzle input, and instead reading by columns, how many of the listed triangles are possible?


File.open('input2.txt') do |f|
  possibles = 0
  f.each_slice(3) do |slice|
    measures  = []
    slice.map do |triangles|
      measures << triangles.strip.split(" ")
    end
    possibles_in_batch = measures.transpose.inject(0) do |counter, dimensions|
      counter += 1 if block.call(dimensions)
      counter
    end
    possibles += possibles_in_batch
  end
  p "Possible triangles problem 2: #{possibles}"
end
