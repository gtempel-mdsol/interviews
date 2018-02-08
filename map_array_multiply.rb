# programming exercise: given an array of numbers,
# replace each number with the product of all the numbers in the array
# EXCEPT the number itself
# WITHOUT using division

# https://www.glassdoor.com/Interview/software-engineer-interview-questions-SRCH_KO0,17.htm

array = Array.new(10) { rand(1..10) }

# or

array = (1..100).to_a


# one possible solution:
# the approach can involve multiplying all the numbers LEFT of the number
# with all the numbers RIGHT of the number, and returning that product
#
array.map.with_index { |n, i| (i == 0 ? 1 : array.slice(0...i).reduce(:*)) *  (i == array.count-1 ? 1 : array.slice(i+1..-1).reduce(:*)) }

