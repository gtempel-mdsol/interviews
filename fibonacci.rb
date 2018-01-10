# programming interview question: determine the Nth digit of the fibonnaci sequence
#
# questions:
#
#   did the candidate design a method or a class?
#   any thoughts regarding testing?

#
# follow-on:
#   modify to print the first N digits
#     how flexible is the implementation? How much rework involved, if any?

def fibonacci(n)
  a = 0
  b = 1

  n.times do
    temp = a
    a = b
    b = temp + b
  end
  a
end

# Write first N Fibonacci numbers in sequence.
n = 10
n.times do |nth|
  result = fibonacci(nth)
  puts result
end
