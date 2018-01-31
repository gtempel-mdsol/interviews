# Prompt: The following is an implementation of a bad user class.
# Identify antipatterns, bugs, code smells, poor design decisions, or
# security vulnerabilities and suggest or write code to improve it.
# User(id: int, name: string, email: string, address: string, password: string)
#
# https://mdsol.jiveon.com/thread/5681
#

# app/models/bad_user.rb
class User < ::ActiveRecord::Base
  GOOGLE_API_SECRET_KEY = 'blahLaLa09'
  EMAIL_REGEX = ('[\w\.%\+\-\']+@(?:[\w\.\-]+\.)+(?:[A-Z]{2,6})').freeze

  # Address(id: integer, user_id: integer, name: string, zip: integer)
  has_many :addresses, dependent: :destroy
  validate :email_syntax

  attr_accessor :id, :name, :email, :address, :age, :password

  def initialize(name, email, age, pass)
    @name, @email, @age, @password = name, email, age, pass
    @@email_regex = Regexp.new('\A' + EMAIL_REGEX + '$', Regexp::IGNORECASE)
  end

  def self.show(params)
    @user = User.send(:find, params[:id])
    respond_to { |format| format.json { render json: @user, status: :ok } }
  end

  def self.find_by_email_or_age(email_or_age)
    where("users.age = #{email_or_age} OR users.email = #{email_or_age}").first
  end

  def address=(address_as_json = {})
    @address = JSON.parse(address_as_json)
  rescue Exception => e
    Rails.logger.error 'An error occurred: #{e.inspect}'
  end

  # Returns everyone who lives at the same address as the user
  def immediate_family
    family_members = []
    addresses.each { |a| family_members << a.users }
    return family_members.flatten.compact.uniq
  end

  # Returns the extended family of the user
  def extended_family
    addresses.map { |a| a.users.map { |u| u.extended_family } }.flatten;
  end

  private

  def increment_age() @age += 1 end

  def email_syntax
    errors.add(:base, "Bad email syntax") if email !~ @@email_regex
  end

  def self.do_something_private
    # doesn't matter what
  end

end

# ================================================================================
comments = <<HERE
Some points:
(1) EMAIL_REGEX -- it's later saved as a class variable (@@)
but see if they question why we'd be using a regex, which also has
its own problems, including no ^ and $ (start/end of line, up until
a newline character which likely won't be here) vs \A and \z for 
start/end of string, but PROBABLY  Additionally, WHY bother with a custom regex
when you could use a gem or the 'mail' gem required by 
ActionMailer (so you'd already have it)

require 'mail'

a = Mail::Address.new(blah)

will throw Mail::Field::ParseError if it's not a compliant email
address

You could build this up as a module (EmailValidate), with a
class EmailValidator with validate_each(record, attribute, value 
that does this check in a begin/rescue


(2) find_by_email_or_age(email_or_age)
There's a possible SQL injection hazard here, could be countered
via:
where('users.age = ? OR users.email = ?', email_or_age, email_or_age)


(3) do_something_private() is a class method (self.blah), but
isn't actually private -- it's still public. In order to make
it private we'd need to do something like this after the method:

  private_class_method :do_something_private

Why? Because 'private' is a method of Module, and when called sets
the visibility of methods defined on the singleton class (metaclass)
of the current object. 

Another approach would be to define the class using self as a block:

class User < ::MactiveRecord::Base
  class << self
    private

    def do_something_private
      # blah 
    end
  end

  #...
end


(3) show() -- what's going on here?
Finding the one asked-for (in params), then rendering it. But WHY
in a model object?

(4) immediate_family() vs extended_family()
What's going on here?
HERE

