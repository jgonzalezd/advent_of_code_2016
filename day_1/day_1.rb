require 'byebug'

# You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.
#
# The Document indicates that you should start at the given coordinates (where you just landed) and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.
#
# There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?
#
# For example:
#
# Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
# R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
# R5, L5, R5, R3 leaves you 12 blocks away.
# How many blocks away is Easter Bunny HQ?

tx = 0
ty = 0
lines = []
curr_dir = ''
last_coordinate = nil

data = File.open('day_1_input_2.txt') {|f| f.readline.strip }
data.split(',').each do |direction|
  # p direction
  d,l = direction.strip.scan(/^([LR])(\d+)$/).flatten
  # p "dir: #{d}"
  # p "dist: #{l}"
  case d
  when 'R'
    (curr_dir = 'S' if curr_dir == 'R') or
    (curr_dir = 'L' if curr_dir == 'S') or
    (curr_dir = 'N' if curr_dir == 'L') or
    (curr_dir = 'R' if curr_dir == 'N')
  when 'L'
    (curr_dir = 'R' if curr_dir == 'S') or
    (curr_dir = 'N' if curr_dir == 'R') or
    (curr_dir = 'S' if curr_dir == 'L') or
    (curr_dir = 'L' if curr_dir == 'N')
  end
  curr_dir = d if curr_dir == ''
  l = l.to_i
  case curr_dir
  when 'N'
    ty += l
  when 'S'
    ty -= l
  when 'R'
    tx += l
  when 'L'
    tx -= l
  end


  last_coordinate ||= [0,0]



  if lines.size > 0
    flag = false
    case curr_dir
    when 'N', 'S'
      x = tx
      ys = last_coordinate[1].downto(ty)
      flag = ys.any? do |y|
        # for each coordinate [x,y]
        lines.any? do |line|
          # Does this line contains [x,y]
          (line.first[0]..line.last[0]).include?(x) && (line.first[1]..line.last[1]).include?(y)
        end
      end
    when 'R', 'L'
      y = ty
      xs = last_coordinate[0].downto(tx)
      flag = xs.any? do |x|
        # for each coordinate [x,y]
        lines.any? do |line|
          # Does this line contains [x,y]
          (line.first[0]..line.last[0]).include?(x) && (line.first[1]..line.last[1]).include?(y)
        end
      end
    end
    if flag
      p [tx, ty]
      p "distance #{tx.abs + ty.abs}"
      break
    end

  end
  lines << [last_coordinate, [tx, ty]]
  last_coordinate = [tx, ty]



end

p (tx.abs + ty.abs)
