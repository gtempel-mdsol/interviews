# how to tell if a string is a palindrome_word?

require 'benchmark'

# could just use built-in functions
# problems?
#   case will throw this off
#   punctuation
#   whitespace
# what about single letter words?
def palindrome_word? text
  text == text.reverse
end

def palindrome? text
  text = text.downcase.scan(/\w/)
  text == text.reverse
end


def manual_palindrome_check? text
  data = text.to_s.downcase
  left = 0
  right = data.length - 1
  while left < right do
    return false if data[left] != data[right]
    left += 1
    right -= 1
  end
  true
end

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

advanced_text = text + [
  'Rats live on no evil star',
  'A man, a plan, a canal. Panama',
  'Step on no pets',
  'Was it a car or a cat I saw?',
  'or other sequence of characters',
  'In girum imus nocte et consumimur igni'
]

text.each do |t|
  puts "standard: #{t} " + (palindrome_word?(t) ? 'IS ' : 'is not ') + 'a palindrome'
  puts "manual: #{t} " + (manual_palindrome_check?(t) ? 'IS ' : 'is not ') + 'a palindrome'
end

advanced_text.each do |t|
  puts "#{t} " + (palindrome?(t) ? 'IS ' : 'is not ') + 'a palindrome'
end


time = Benchmark.bmbm do |benchmark|
  benchmark.report('standard') do
    text.each do |t|
      palindrome_word?(t)
    end
  end
  benchmark.report('manual') do
    text.each do |t|
      manual_palindrome_check?(t)
    end
  end
end
