# programming interview problem: determine if (some text) is a palindrome
#
# initially, don't ask "determine if a word is a palindrome", as we want to see
#   if the candidate asks questions and thinks-through to a more generalized approach.
#
# questions:
#   did candidate create a class or a method/function?
#   is the solution functional for just a word?
#   did the candidate use built-in functions or a manual implementation?
#   possible problems:
#     case
#     punctuation
#     whitespace
#     what about single letter words?
#     is a single letter word a palindrome?
#
#   did the candidate think about performance?
#     especially if the solution normalizes case on individual characters within 
#       the loop of a manual solution

require 'benchmark'

# could just use built-in functions
# possible problems:
#   case
#   punctuation
#   whitespace
def palindrome_word? text
  text == text.reverse
end

# normalize the case, look for only word characters
def palindrome_normalized? text
  text = text.strip.downcase.scan(/\w/)
  text == text.reverse
end

# one possible manual solution
def palindrome_manual_check? text
  # watch to see if candidates consider any of the things that
  # could cause problems, such as leading/trailing whitespace, 
  # case, punctuation, etc.
  data = text.to_s.strip.downcase
  left = 0
  # watch for candidates' off-by-one errors here
  right = data.length - 1
  # do candidates use a fixed for loop that iterates
  # halfway through the text? Do they handle odd vs
  # even length text differently? Or they just check
  # the left vs right indices?
  while left < right do
    return false if data[left] != data[right]
    left += 1
    right -= 1
  end
  true
end

# sample text to test...feel free to add to this
text = %w[
  a
  foo
  foobar
  racecar
  civic
  kayak
  rotator
  machine
  Noon
]

# these will only work if the solution considers palindromic phrases
advanced_text = text + [
  'Rats live on no evil star',
  'A man, a plan, a canal. Panama',
  'Step on no pets',
  'Was it a car or a cat I saw?',
  'a sequence of characters that is not a palindrome?',
  'In girum imus nocte et consumimur igni'
]

# compare results
text.each do |t|
  puts "standard: " + (palindrome_word?(t) ? 'YES ' : 'no  ') + ": #{t}"
  puts "manual:   " + (palindrome_manual_check?(t) ? 'YES ' : 'no  ')  + ": #{t}"
end

advanced_text.each do |t|
  puts (palindrome_normalized?(t) ? 'YES ' : 'no  ') + ": #{t}"
end

# benchmark for comparison of approaches
time = Benchmark.bmbm do |benchmark|
  benchmark.report('basic') do
    text.each do |t|
      palindrome_word?(t)
    end
  end
  benchmark.report('normalized') do
    text.each do |t|
      palindrome_word?(t)
    end
  end
  benchmark.report('manual') do
    text.each do |t|
      palindrome_manual_check?(t)
    end
  end
end
