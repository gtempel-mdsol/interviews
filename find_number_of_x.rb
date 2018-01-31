# programming problem: find the number of 'a' in the string
# Ruby is a great programming language
# https://mdsol.jiveon.com/docs/DOC-7392


text = 'Ruby is a great programming language'
needle = 'a'

puts "Number of #{needle} in '#{text}': " + text.count(needle).to_s

puts "Number of #{needle} in '#{text}': " + text.scan(Regexp.new(needle)).count.to_s
