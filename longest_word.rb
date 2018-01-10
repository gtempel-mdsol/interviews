# programming interview problem: find the longest word in a set of input
#
# several ways to do this:
# collect, sort by length, get max
# collect, reduce
# collect, iterate via inject
# use array functions

require 'benchmark'

# Some sample implementations here, as methods in an object
# simply so we can do some benchmark comparison of the implementations

class WordLength
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

  def compare_approaches data
    # public_instance_methods(false).select { |m| }
    method_names_to_compare = public_methods(false).select {|m| m.to_s.start_with?('via_') }
    Benchmark.bmbm do |benchmark|
      method_names_to_compare.each do |method_name|
        benchmark.report(method_name) { puts self.send(method_name, data) }
      end
    end
  end
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

wl = WordLength.new
wl.compare_approaches data

