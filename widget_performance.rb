# programming question: understanding performance
#

# given this class
class Widget
  attr_accessor :id
  def initialize(id: 1)
    @id = id
  end
end

widgets = (1..1000).select(&:even?).inject([]) { |collection, n| collection << Widget.new(id: n) }


# which is faster? how would you measure?
widget_ids = widgets.map { |w| w.id }
widget_ids = widgets.map(&:id)
widget_ids = widgets.inject([]) { |a, w| a.push(w.id) }
widget_ids = widgets.collect { |w| w.id }

require 'benchmark'

time = Benchmark.bmbm do |x|
  x.report('map of id') { widgets.map { |w| w.id } }
  x.report('map using symbol') { widgets.map(&:id) }
  x.report('inject') { widgets.inject([]) { |a, w| a.push(w.id) } }
  x.report('collect') { widgets.collect { |w| w.id } }
end
