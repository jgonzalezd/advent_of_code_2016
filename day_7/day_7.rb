require 'byebug'
# --- Day 7: Internet Protocol Version 7 ---
#
# While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS (transport-layer snooping).
#
# An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, which are contained by square brackets.
#
# For example:
#
# abba[mnop]qrst supports TLS (abba outside square brackets).
# abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
# aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
# ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).
# How many IPs in your puzzle input support TLS?



# --- Part Two ---
#
# You would also like to know which IPs support SSL (super-secret listening).
#
# An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists of the same character twice with a different character between them, such as xyx or aba. A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.
#
# For example:
#
# aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
# xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
# aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
# zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).
# How many IPs in your puzzle input support SSL?

block_abba = Proc.new do |chars|
  chars.split("").each_cons(4).any? do |chars_slice|
    (chars_slice == chars_slice.reverse) && (chars_slice[0] != chars_slice[1])
  end
end

block_aba = Proc.new do |chars|
  chars.split("").each_cons(3).inject([]) do |memo, chars_slice|
    memo << chars_slice  if (chars_slice == chars_slice.reverse) && (chars_slice[0] != chars_slice[1])
    memo
  end
end

file = File.open('input.txt')
counter = 0
counter_aba = 0
file.each_line do |line|
  outsiders = []
  insiders  = []
  line.strip.scan(/([^\[\]]+)(\[[a-z]+\])?/).each do |occurrence|
    outsiders << occurrence[0]
    insiders  << occurrence[1] unless occurrence[1].nil?
  end
  insiders     = insiders.map { |str| str.gsub(/[\[\]]/,'') }
  abba_outside = outsiders.any? { |chars| block_abba.call(chars) }
  abba_in_ip   = false
  if abba_outside
    abba_in_ip = insiders.any? { |chars| block_abba.call(chars) }
    counter += 1 unless abba_in_ip
  end

  # Part two
  aba_arr = outsiders.inject([]) { |memo, chars| memo += block_aba.call(chars) }
  bab_arr = aba_arr.map { |aba| aba.take(2).reverse.push(aba[1]) }
  if aba_arr.size > 0
    counter_aba += 1 if insiders.any? { |chars| bab_arr.any? { |bab| Regexp.union(bab.join) =~ chars } }
  end
end
file.close
p counter
p counter_aba
