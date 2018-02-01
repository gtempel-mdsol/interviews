# programming question: understanding performance
#

# given this class
class Widget
  attr_accessor :id
  def initialize(id: 1)
    @id = id
  end
end

# which is faster? how would you measure?
# widget_ids = widgets.map { |w| w.id }
# widget_ids = widgets.map(&:id)
# widget_ids = widgets.inject([]) { |a, w| a.push(w.id) }
# widget_ids = widgets.collect { |w| w.id }
# widget_ids = widgets.collect(&:id)
# widget_ids = widgets.pluck(:id) # only for active record

# ==================

# if you want a non-sequential collection then select something out of
# the range, perhaps just the even?
# .select(&:even?)...
widgets = (1..10000).inject([]) { |collection, n| collection << Widget.new(id: n) }

require 'benchmark'

benchmarks = Benchmark.bmbm do |x|
  x.report('map') { widgets.map { |w| w.id } }
  x.report('map(&:id)') { widgets.map(&:id) }
  x.report('inject') { widgets.inject([]) { |a, w| a.push(w.id) } }
  x.report('collect') { widgets.collect { |w| w.id } }
  x.report('collect(&:id)') { widgets.collect(&:id) }
  # x.report('pluck') { widgets.pluck(:id) }
end

# which was fastest?
benchmarks.sort! { |a, b| a.real <=> b.real }
puts "Results\n#{'-' * 30}"
benchmarks.each { |a| puts "#{a.label.ljust(20)}: #{a.real} "}

# when using active record:
# collect and map cases will return the collection of active records from the database,
# then loop on the collection to extract the information; this is full marshalling of
# records from the database, then operating on the entire collection.
#
# pluck diredtly returns array of the attribute we pass in, and also selects ONLY those
# attributes while querying, thus rails fetches just what's asked for without an
# extra loop to get the ids from the collection.
#
# other good info:
# https://rubyinrails.com/2014/06/05/rails-pluck-vs-select-map-collect/
# https://www.webascender.com/blog/rails-tips-speeding-activerecord-queries/
# https://medium.com/@amliving/activerecords-select-pluck-3d5c58872053
# https://collectiveidea.com/blog/archives/2015/05/29/how-to-pluck-like-a-rails-pro


