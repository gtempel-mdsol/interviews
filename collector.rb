# interview programming problem: collecting words, determining frequency
#
# ask for input from user (or stdin or whatever)
# for every input received:
#   if unique, keep it
#   if non-unique, report non-unique
#     bonus/extra: ...and how many times we've seen it
#       bonus/extra: interactively or via batch? Good thinking
#
# easy approach:
#   could simply collect everything, then detect duplicates and counts
#
# better approach:
#   use a hash or set, and detect/probe for existence, and increment a value
#
# follow-on questions for the candidate:
#   did the candidate just do a method/function, or work-up a class?
#   does case matter?
#   removing 'common' words?
#   phrases vs words?
#   did the candidate talk about testing?

require 'JSON'

#==========

# arbitrary collection of speeches that can be used as source text
text = { }

# Martin Luther King's "I Have A Dream" speech
text[:mlk] = <<EOL
I say to you today, my friends, that in spite of the difficulties and frustrations of the moment, I still have a dream. It is a dream deeply rooted in the American dream.
I have a dream that one day this nation will rise up and live out the true meaning of its creed: "We hold these truths to be self-evident: that all men are created equal."
I have a dream that one day on the red hills of Georgia the sons of former slaves and the sons of former slave-owners will be able to sit down together at a table of brotherhood.
I have a dream that one day even the state of Mississippi, a desert state, sweltering with the heat of injustice and oppression, will be transformed into an oasis of freedom and justice.
I have a dream that my four children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character.
I have a dream today.
I have a dream that one day the state of Alabama, whose governors lips are presently dripping with the words of interposition and nullification, will be transformed into a situation where little black boys and black girls will be able to join hands with little white boys and white girls and walk together as sisters and brothers.
I have a dream today.
I have a dream that one day every valley shall be exalted, every hill and mountain shall be made low, the rough places will be made plain, and the crooked places will be made straight, and the glory of the Lord shall be revealed, and all flesh shall see it together.
EOL

# gettysburg address
text[:gettysburg] = <<EOL
Four score and seven years ago our fathers brought forth, upon this 
continent, a new nation, conceived in liberty, and dedicated to the 
proposition that "all men are created equal" 

Now we are engaged in a great civil war, testing whether that 
nation, or any nation so conceived, and so dedicated, can long endure. 
We are met on a great battle field of that war. We have come to 
dedicate a portion of it, as a final resting place for those who died here, that 
the nation might live. This we may, in all propriety do. But, in a 
larger sense, we can not dedicate — we can not consecrate — we can not 
hallow, this ground — The brave men, living and dead, who struggled 
here, have hallowed it, far above our poor power to add or detract. 
The world will little note, nor long remember what we say here; while 
it can never forget what they did here. 

It is rather for us, the living, we here be dedicated to the great task 
remaining before us — that, from these honored dead we take increased 
devotion to that cause for which they here, gave the last full measure 
of devotion — that we here highly resolve these dead shall not have died 
in vain; that the nation, shall have a new birth of freedom, and that 
government of the people by the people for the people, shall not perish 
from the earth.
EOL

text[:churchill] = <<EOL
Even though large tracts of Europe and many old and famous States have fallen or may fall 
into the grip of the Gestapo and all the odious apparatus of Nazi rule, we shall not flag 
or fail. We shall go on to the end. We shall fight in France, we shall fight on the seas 
and oceans, we shall fight with growing confidence and growing strength in the air, we shall 
defend our island, whatever the cost may be. We shall fight on the beaches, we shall fight 
on the landing grounds, we shall fight in the fields and in the streets, we shall fight in 
the hills; we shall never surrender, and if, which I do not for a moment believe, this island 
or a large part of it were subjugated and starving, then our Empire beyond the seas, armed 
and guarded by the British Fleet, would carry on the struggle, until, in Gods good time, 
the New World, with all its power and might, steps forth to the rescue and the liberation of the old.
EOL

# A possible class implementation here.
class WordCollector
  
  COMMON = %w[
    a
    an
    the
    that
    of
    for
    and
    to
  ]

  def initialize words_to_ignore = COMMON
    @words_to_ignore = words_to_ignore.inject({}) { |h, v| h[v] = v.to_s.downcase.strip; h}
    puts @words_to_ignore
    @words = { }
  end

  def collect word
    w = word.downcase.strip
    @words[word] = @words.fetch(w, 0) + 1 unless w.empty? || @words_to_ignore.key?(w)
  end

  def unique
    @words.select { |k,v| v == 1 }
  end

  def repeated
    @words.select { |k,v| v > 1 }
  end

  def most_repeated
    @words.max_by{|k,v| v}
  end

end

# ==================
# choose which speech to analyze...just pick one and comment out the others
text_key = :mlk
text_key = :gettysburg
text_key = :churchill

wc = WordCollector.new
words = text[text_key].split(/[\W\s]/).each do |w|
  wc.collect w
end

# pretty print
puts "Unique words for #{text_key}: "    + JSON.pretty_generate(wc.unique).gsub(":", " =>")
puts "Repeated words: #{text_key}: "     + JSON.pretty_generate(wc.repeated).gsub(":", " =>")
puts "Most repeated word: #{text_key}: " + JSON.pretty_generate(wc.most_repeated).gsub(":", " =>")
