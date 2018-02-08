# programing question: understanding ruby collection operations
# https://mdsol.jiveon.com/docs/DOC-7392

# sum the values from 5 to 26

range = (5..26)

# solution 1
range.reduce(:+)

# solution 2
total = 0
range.each { |n| total += n }

# solution 3
#require 'activesupport' # if < ruby 2.4.0
range.to_a.sum

# solution 4 ... not nice, monkeypatching
class Array
  def sum
    inject { |sum, x| sum + x }
  end
end
range.to_a.sum

# solution 5
range.to_a.inject(&:+)

# solution 6
range.to_a.inject(0, &:+)

# solution 7  # if >= ruby 2.4.0
range.sum
range.inject(&:+)
range.inject(0, &:+)





# sum the values form 5 to 26 that have an integer square root
# any of the above, but filter out or ignore those that don't have an integer square root
range.select{|n| Math::sqrt(n) % 1 == 0}.sum # for ruby >= 2.4 otherwise must use one of the above
range.select{|n| Math::sqrt(n) % 1 == 0}.inject(&:+)


require 'benchmark'

range = (5..26)
total = 0
benchmarks = Benchmark.bmbm do |x|
  x.report('reduce') { range.reduce(:+) }
  x.report('loop') { range.each { |n| total += n } }
  x.report('inject symbol') { range.to_a.inject(&:+) }
  x.report('inject value') { range.to_a.inject(0, &:+) }
  x.report('range sum') { range.sum }
  x.report('range inject symbol') { range.inject(&:+) }
  x.report('range inject value') { range.inject(0, &:+) }
}


end

# which was fastest?
benchmarks.sort! { |a, b| a.real <=> b.real }
puts "Results\n#{'-' * 30}"
benchmarks.each { |a| puts "#{a.label.ljust(20)}: #{a.real} "}
