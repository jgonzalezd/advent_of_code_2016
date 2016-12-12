require "byebug"
require 'matrix'

# --- Day 8: Two-Factor Authentication ---
#
# You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.
#
# To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.
#
# Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.
#
# The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:
#
# rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
# rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
# rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
# For example, here is a simple sequence on a smaller screen:
#
# rect 3x2 creates a small rectangle in the top-left corner:
#
# ###....
# ###....
# .......
# rotate column x=1 by 1 rotates the second column down by one pixel:
#
# #.#....
# ###....
# .#.....
# rotate row y=0 by 4 rotates the top row right by four pixels:
#
# ....#.#
# ###....
# .#.....
# rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:
#
# .#..#.#
# #.#....
# .#.....
# As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.
#
# There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?

file = File.open('input.txt')
display = Matrix.build(6, 50){|row, col| 0}
# display = Matrix.build(3, 7){|row, col| 0}
puts display.to_a.map {|e| e.inspect}
display_cp = display.to_a
file.each_line do |line|
  action, command = line.match(/([a-z]+)\s(.*)/).values_at(1,2)
  if action == 'rect'
    rows, columns = command.match(/(\d+)x(\d+)/).values_at(1,2).map(&:to_i)
    0.upto(columns-1).each_with_index do |row|
      0.upto(rows-1).each_with_index{|column| display_cp[row][column] = 1 }
    end
  else
    direction, position, times = command.match(/[a-z\s](.)=(\d+)[by\s]+(\d+)/).values_at(1,2,3)
    position = position.to_i
    times = times.to_i
    if direction == 'x'
      display_t = display_cp.transpose
      display_t[position] = display_t[position].rotate(-times)
      display_cp = display_t.transpose
    else
      display_cp[position] = display_cp[position].rotate(-times)
    end
  end
  p '-----------------out----------------'
  display_cp.each{|row| puts row.join}
end
p display_cp.inject(0){|t_count, e| t_count+= e.inject(0) {|count, e| e == 1 ? count += 1 : count } }
file.close

# --- Part Two ---
#
# You notice that the screen is only capable of displaying capital letters; in the font it uses, each letter is 5 pixels wide and 6 tall.
#
# After you swipe your card, what code is the screen trying to display?
display_t = display_cp.transpose
while display_t.size>0
  p '---------------------code----------------------------'
  display_t.shift(5).transpose.each{|row| puts row.map{|e| e==1 ? '#' : '.'}.join}
end
