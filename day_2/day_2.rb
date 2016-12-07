require 'byebug'

# --- Day 2: Bathroom Security ---
#
# You arrive at Easter Bunny Headquarters under cover of darkness. However, you left in such a rush that you forgot to use the bathroom! Fancy office buildings like this one usually have keypad locks on their bathrooms, so you search the front desk for the code.
#
# "In order to improve security," the document you find says, "bathroom codes will no longer be written down. Instead, please memorize and follow the procedure below to access the bathrooms."
#
# The document goes on to explain that each button to be pressed can be found by starting on the previous button and moving to adjacent buttons on the keypad: U moves up, D moves down, L moves left, and R moves right. Each line of instructions corresponds to one button, starting at the previous button (or, for the first line, the "5" button); press whatever button you're on at the end of each line. If a move doesn't lead to a button, ignore it.
#
# You can't hold it much longer, so you decide to figure out the code as you walk to the bathroom. You picture a keypad like this:
#
# 1 2 3
# 4 5 6
# 7 8 9
# Suppose your instructions are:
#
# ULL
# RRDDD
# LURDL
# UUUUD
# You start at "5" and move up (to "2"), left (to "1"), and left (you can't, and stay on "1"), so the first button is 1.
# Starting from the previous button ("1"), you move right twice (to "3") and then down three times (stopping at "9" after two moves and ignoring the third), ending up with 9.
# Continuing from "9", you move left, up, right, down, and left, ending with 8.
# Finally, you move up four times (stopping at "2"), then down once, ending with 5.
# So, in this example, the bathroom code is 1985.


def search_pass(keyboard)
  current_key = nil
  data = File.open('input.txt') do |f|
    f.each_with_index do |line, i|
      line.strip.split("").each do |next_key|
        current_key ||= 5
        key = keyboard[current_key][next_key.to_sym]
        current_key = key unless key.nil?
      end
      p current_key
    end
  end
end


keyboard_1 = {
  1 => {U: nil,  R: 2,    D: 4,    L: nil},
  2 => {U: nil,  R: 3,    D: 5,    L: 1},
  3 => {U: nil,  R: nil,  D: 6,    L: 2},
  4 => {U: 1,    R: 5,    D: 7,    L: nil},
  5 => {U: 2,    R: 6,    D: 8,    L: 4},
  6 => {U: 3,    R: nil,  D: 9,    L: 5},
  7 => {U: 4,    R: 8,    D: nil,  L: nil},
  8 => {U: 5,    R: 9,    D: nil,  L: 7},
  9 => {U: 6,    R: nil,  D: nil,  L: 8}
}
p "-----------ONE----------------"
search_pass keyboard_1
#
# --- Part Two ---
#
# You finally arrive at the bathroom (it's a several minute walk from the lobby so visitors can behold the many fancy conference rooms and water coolers on this floor) and go to punch in the code. Much to your bladder's dismay, the keypad is not at all like you imagined it. Instead, you are confronted with the result of hundreds of man-hours of bathroom-keypad-design meetings:
#
#     1
#   2 3 4
# 5 6 7 8 9
#   A B C
#     D
# You still start at "5" and stop when you're at an edge, but given the same instructions as above, the outcome is very different:
#
# You start at "5" and don't move at all (up and left are both edges), ending at 5.
# Continuing from "5", you move right twice and down three times (through "6", "7", "B", "D", "D"), ending at D.
# Then, from "D", you move five more times (through "D", "B", "C", "C", "B"), ending at B.
# Finally, after five more moves, you end at 3.
# So, given the actual keypad layout, the code would be 5DB3.
#
# Using the same instructions in your puzzle input, what is the correct bathroom code?
#

keyboard_2 = {
  1 => {U: nil,  R: nil,    D: 3,    L: nil},
  2 => {U: nil,  R: 3,      D: 6,    L: nil},
  3 => {U: 1,    R: 4,      D: 7,    L: 2},
  4 => {U: nil,  R: nil,    D: 8,    L: 3},
  5 => {U: nil,  R: 6,      D: nil,  L: nil},
  6 => {U: 2,    R: 7,      D: :A,   L: 5},
  7 => {U: 3,    R: 8,      D: :B,   L: 6},
  8 => {U: 4,    R: 9,      D: :C,   L: 7},
  9 => {U: nil,  R: nil,    D: nil,  L: 8},
  A:   {U: 6,    R: :B,     D: nil,  L: nil},
  B:   {U: 7,    R: :C,     D: :D,   L: :A},
  C:   {U: 8,    R: nil,    D: nil,  L: :B},
  D:   {U: :B,   R: nil,    D: nil,  L: nil},
}
p "----------TWO---------------"
search_pass keyboard_2

# Use the
