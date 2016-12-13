require 'byebug'

# --- Day 9: Explosives in Cyberspace ---
#
# Wandering around a secure area, you come across a datalink port to a new part of the network. After briefly scanning it for interesting files, you find one file in particular that catches your attention. It's compressed with an experimental format, but fortunately, the documentation for the format is nearby.
#
# The format compresses a sequence of characters. Whitespace is ignored. To indicate that some sequence should be repeated, a marker is added to the file, like (10x2). To decompress this marker, take the subsequent 10 characters and repeat them 2 times. Then, continue reading the file after the repeated data. The marker itself is not included in the decompressed output.
#
# If parentheses or other characters appear within the data referenced by a marker, that's okay - treat it like normal data, not a marker, and then resume looking for markers after the decompressed section.
#
# For example:
#
# ADVENT contains no markers and decompresses to itself with no changes, resulting in a decompressed length of 6.
# A(1x5)BC repeats only the B a total of 5 times, becoming ABBBBBC for a decompressed length of 7.
# (3x3)XYZ becomes XYZXYZXYZ for a decompressed length of 9.
# A(2x2)BCD(2x2)EFG doubles the BC and EF, becoming ABCBCDEFEFG for a decompressed length of 11.
# (6x1)(1x3)A simply becomes (1x3)A - the (1x3) looks like a marker, but because it's within a data section of another marker, it is not treated any differently from the A that comes after it. It has a decompressed length of 6.
# X(8x2)(3x3)ABCY becomes X(3x3)ABC(3x3)ABCY (for a decompressed length of 18), because the decompressed data from the (8x2) marker (the (3x3)ABC) is skipped and not processed further.
# What is the decompressed length of the file (your puzzle input)? Don't count whitespace.

class Marker
  REGEX = /\A(\()(\d*)(x?)(\d*)(\)?)\z/

  attr_reader :builder


  def initialize(str=nil)
    if str.nil?
      @builder =  ""
    else
      @builder = str
    end
  end

  def <<(str)
    builder_cp = builder
    builder_cp << str #String method
    if Marker.new(builder_cp).valid? #like (1, (10, (10x, (10x2, (10x2)
      builder= builder_cp
    else
      builder_cp = nil #call GC
      builder
    end
  end

  def matcher
    builder.match(REGEX)
  end

  def clean
    @builder = nil
  end

  def string_size
    matcher.values_at(2).shift.to_i
  end

  def times
    matcher.values_at(4).shift.to_i
  end

  def complete?
    builder && !matcher.captures.last.empty?
  end

  def valid?
    false unless matcher
  end

  def nil?
    builder.nil?
  end

  def to_s
    builder || ""
  end
end

def decompress(line_a, file = nil)
  marker = nil
  index = 0
  char = nil
  str = ""
  while line_a.size > 0 && index < line_a.size do
    char = line_a[index]
    puts '--------------------progress-------------------------'
    puts "line size => #{line_a.size}"
    puts "char =>  #{char}"
    p line_a.take(index).join
    puts "marker start => "+ marker.to_s
    if marker && marker.complete?
      puts 'marker complete => '+marker.to_s
      line_a.shift(index)
      str_to_add = line_a.shift(marker.string_size).join
      str << decompress(str_to_add.strip.split(""))
      puts "adds #{str_to_add} #{marker.times.to_s} times"
      str << str_to_add * marker.times
      marker.clean
      index = 0
      next
    else
      marker = Marker.new if char == "(" && marker.nil?
      marker.nil? ? str << char : marker << char
      index += 1
      puts "marker end =>"+marker.to_s
      puts "index =>"+index.to_s
    end
  end
  file.write(str) unless file.nil?
  str
end


# Starts here


input_file = File.open('input.txt')
output_file = File.open('output.txt','w')
str = ""

input_file.each_line do |line|
  line_a = line.strip.split("")
  begin
    decompress(line_a, output_file)
  rescue IOError => e
    puts 'ERROR: something happened while processing.'
  ensure
    output_file.close
  end
end
input_file.close

p str.size
chunk_size = 1024
total_decompressed = 0
output_file = File.open('output.txt').each(nil, chunk_size) do |chunk|
  total_decompressed += chunk.size
end
output_file.close

p "Total decompressed PART II #{total_decompressed}"
