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

# Solution to Part I
# def decompress(line_a)
#   marker = nil
#   index = 0
#   char = nil
#   str = ""
#   while line_a.size > 0 && index < line_a.size do
#     char = line_a[index]
#     if marker && marker.complete?
#       line_a.shift(index)
#       str_to_add = line_a.shift(marker.string_size).join
#       str << str_to_add * marker.times #Instead of writing the string just count chars
#       marker.clean
#       index = 0
#       next
#     else
#       marker = Marker.new if char == "(" && marker.nil?
#       marker.nil? ? str << char : marker << char
#       index += 1
#     end
#   end
#   str
# end



# Writing file (Very inefficient) Part II
loop do
  output_file = File.open('output.txt','w')
  input_file = File.open('input.txt')
  initial_size = File.size('input.txt')
  puts "Starting. File size #{initial_size}"
  num_of_chunks = nil
  times = nil
  buffer = ""
  marker = nil
  input_file.each(nil, 1) do |chunk|
    if num_of_chunks && num_of_chunks > 0
      num_of_chunks -= 1
      buffer << chunk
      next if num_of_chunks > 0
    end

    if buffer.size > 0
      output_file.write(buffer * times)
      times = nil
      num_of_chunks = nil
      buffer = ""
      marker = nil
      next
    end

    marker = Marker.new if chunk == "(" && marker.nil?
    marker.nil? ? output_file.write(chunk) : marker << chunk

    if marker && marker.complete?
      num_of_chunks = marker.string_size
      times = marker.times
      marker.clean
    end
  end
  input_file.close
  output_file.close

  final_size = File.size('output.txt')
  break if initial_size == final_size
  puts "Finished File size #{final_size}"
  File.delete('input.txt')
  File.rename('output.txt', 'input.txt')
end


chunk_size = 1
total_decompressed = 0
output_file = File.open('output.txt').each(nil, chunk_size) do |chunk|
  next if chunk == "\n"
  total_decompressed += chunk.size
end
puts "total: #{total_decompressed}"
output_file.close
