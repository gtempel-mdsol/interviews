# programming exercise: given a reliable (3rd party guaranteed) structure

input = [	
  {a1: 42, b1: { c1: 'foo' }}, 
  {a2: 43, b2: { c2: 'bar' }}, 
  {a3: 44, b3: { c3: 'baz' }}
  # … 
]

# extract an array of cN values (['foo', 'bar', 'baz'])
# where n = 1, 2, 3, etc...basically grab the c1, c2, c3 values


# how is the candidate handling determining getting value of the lone key in the hash
# that's the value for the 2nd element of the hash?
#
# basically...
# iteratore through the array, collecting nested hashes and using an index
# to build the requested key name
#
# however...
# hash is an enumerable, so you can work your way there without the
# key mangling:

input.map { |v| v.to_a.last.last.to_a.last.last }

# or

input.map { |v| v.flatten.last.flatten.last }


