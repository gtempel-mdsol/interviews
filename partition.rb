# interview programming problem: partition collection of numbers into odd and even collections
#
# write code that will take a collection of numbers and split it
# into two collections, the odds and the evens
#
# could do this one at a time
# could do this in bulk
#
# questions:
#   does the candidate consider scale (size of the collection)
#   does the candidate consider built-ins vs manual checks?
#   is the candidate able to tell which might perform better and why? 

require 'json'
require 'benchmark'

def with_iterator array_of_numbers
  array_of_numbers.each_with_object({odd:[], even:[]}) do |elem, memo|
    memo[elem.odd? ? :odd : :even] << elem
  end # inject for ruby < 2.0 is fine as well
end

def one_liner array_of_numbers
  %i|select reject|.map { |m| array_of_numbers.partition(&:odd?)}
end

#=============

max_number = 10000000
array_of_numbers = (0..max_number).to_a

results = with_iterator array_of_numbers
#puts 'partitioning via with_iterator yields: ' + JSON.pretty_generate(results)

results = one_liner array_of_numbers
#puts 'partitioning via one_linder yields: ' + JSON.pretty_generate(results)

#===========

# how could we know which performs better?
# which is more performant? 
# why?
# (the one liner actually starts to take longer)

time = Benchmark.bmbm do |x|
  x.report('with_iterator') { with_iterator array_of_numbers }
  x.report('one_liner') { one_liner array_of_numbers }
end
