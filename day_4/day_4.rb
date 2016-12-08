require 'byebug'
# --- Day 4: Security Through Obscurity ---
#
# Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.
#
# Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.
#
# A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:
#
# aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
# a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
# not-a-real-room-404[oarel] is a real room.
# totally-real-room-200[decoy] is not.
# Of the real rooms from the list above, the sum of their sector IDs is 1514.
#
# What is the sum of the sector IDs of the real rooms?

# file = File.open('input.txt')
# sum = 0
# file.each_line do |line|
#   string, code, checksum = line.strip.match(/\A([a-z-]+)(\d+)\[([a-z]{5})\]\z/).values_at(1,2,3)
#   string = string.gsub('-','').split('')
#   calculated_checksum = string.each_with_object(Hash.new(0)){ |e, hist| hist[e] += 1 }.sort_by{ |e| [-e[1], e[0]] }.to_h.keys.take(5).join
#   sum += code.to_i if calculated_checksum == checksum
# end
# file.close
#
# p sum

# --- Part Two ---
#
# With all the decoy data out of the way, it's time to decrypt this list and get moving.
#
# The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.
#
# To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.
#
# For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.
#
# What is the sector ID of the room where North Pole objects are stored?
#

def play_pass(str,n)
  abc = ("a".."z").to_a.join
  abc_rot = abc.chars.rotate(n).join
  str.tr(abc, abc_rot)
end

file = File.open('input.txt')
sum = 0
file.each_line do |line|
  string, code, checksum = line.strip.match(/\A([a-z-]+)(\d+)\[([a-z]{5})\]\z/).values_at(1,2,3)

  string_arr = string.gsub('-','').split('')
  calculated_checksum = string_arr.each_with_object(Hash.new(0)){ |e, hist| hist[e] += 1 }.sort_by{ |e| [-e[1], e[0]] }.to_h.keys.take(5).join
  if calculated_checksum == checksum
    phrase = []
    cyphered_words = string.split("-").map do |c_word|
      phrase << play_pass(c_word, code.to_i)
    end
    sentence = phrase.join(" ")
    p code if sentence.include?('north')
  end
end
file.close
