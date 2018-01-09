# find the longest word in a set of input

# several ways to do this:
# collect, sort by length, get max
# collect, reduce
# collect, iterate via inject
# use array functions

require 'benchmark'


def via_iterator data
  max_item = data.first
  data.each do |e| 
    max_item = max_item.length > e.length ? max_item : e
  end
  max_item
end

def via_max_by data
  data.max_by(&:length)
end

def via_map_max data
  # doesn't return the word, just the length
  data.map(&:length).max
end

def via_inject data
  data.inject { |f, s| f.length > s.length ? f : s }
end

def via_reduce data
  data.reduce { |m, e| m.length > e.length ? m : e }
end

#======================

data = %w[
  rats
  bears
  letters
  elephants
  ace
  volkswagen
  encyclopedia
  foo
  bar
]

time = Benchmark.bmbm do |benchmark|
  benchmark.report('each: ') { puts via_iterator(data) }
  benchmark.report('max_by: ') { puts via_max_by(data) }
  benchmark.report('map_max: ') { puts via_map_max(data) }
  benchmark.report('inject: ') { puts via_inject(data) }
end
