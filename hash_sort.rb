# programming question: given a hash, sort the keys by the length of the key as a string

hash_data = {
  abc: 'hello',
  'another_key': 123,
  4567 => 'third',
  '911' => 'emergency services',
  more: 'more',
  less: 'less'
}





#====================
# from: https://www.toptal.com/ruby/interview-questions

# one-liners:
hash_data.keys.map(&:to_s).sort_by(&:length)
hash_data.keys.collect(&:to_s).sort_by { |key| key.length }

def key_sort hash_data
	hash_data.keys.collect(&:to_s).sort { |a, b| a.length <=> b.length }
end

