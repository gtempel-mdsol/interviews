# programming question: tests knowledge of classes
# https://mdsol.jiveon.com/docs/DOC-7392

class User
  attr_reader :name
  def self.say_this(to_say = 'Hi!')
    puts to_say
  end
end

# what happens?
user = User.new
user.name = 'Joe'
# should get an error as name= is undefined; use attr_accessor if you want to get this


# what happens?
user = User.new
user.say_this

# error because say_this is a class method, and can't be invoked from an instance unless
# user.class.say_this
# in which case it will emit "Hi!"
