# find the divergent/exclusive set (items that appear in 1 and only 1 collection)

# can do this with arrays as well as sets
# (a - b) | (b - a)

# order is O(n)

require 'set'

a = Set.new %w[ a b c d e f g h i j k l m n o p q r s t u v w x y z ]
b = Set.new %w[ a e i o u ]
c = Set.new %w[ r s t l n ]

puts 'a ^ b = '     + (a ^ b).to_a.to_s
puts 'a ^ c = '     + (a ^ c).to_a.to_s
puts 'a ^ b ^ c = ' + (a ^ b ^ c).to_a.to_s
