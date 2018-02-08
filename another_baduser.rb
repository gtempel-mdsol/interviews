class User < ActiveRecord::Base

  MAILCHIMP_API_KEY = 'm23lm092m3'

  has_many :orders
  has_many :packages, through: :orders

  before_save :assign_referral_code, on: :create
  after_create :schedule_welcome_email
  
  validates_presence_of :email, :fname, :lname
  validates :referral_code, uniqueness: true

  scope :recently_created, where("created_at <= #{Date.today - 2.days}")

  def name
    self.fname + ' ' + self.lname
  end

  def formatted_name
    "<strong>#{name}</strong> (<a href=\"mailto:#{email}\">#{email}</a>)"
  end

  def assign_referral_code
    referral_code = SecureRandom.hex(6)
  end

  def schedule_welcome_email
    Mailer.delay.welcome(self) # Queue email with DelayedJob
  end

  def has_orders
    orders.any?
  end

  def most_recent_package_shipping_address
    order.last.package.shipping_address
  end

  def can_manage?
    (email = 'manager@example.com') or (email = 'admin@example.com')
  end

  def order_product(product)
    result = OrderProcessor.charge(self, product)

    if result
      Event.log_order_processing(self)
      Mailer.order_confirmation(self, product).deliver
      return true
    else
      Event.log_failed_order_processing(self)
      return false
    end
  end

  def self.delete_user(email)
    begin
      user = User.find_by_email(email)
      user.destroy!
    rescue Exception => e # email not found
      Rails.logger.error("Could not delete user with email #{email}")
    end
  end

end

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string(255)      default(""), not null
#  fname                     :string(255)      default(""), not null
#  lname                     :string(255)      default(""), not null
#  referral_code             :string(255)
#  created_at                :datetime
#  updated_at                :datetime







# line 3:
# Configuration variables, API keys, and passwords belong in ".gitignore"d configuration files.

# line 5:
# Associated records generally need dependent: :destroy or other behavior defined in the event of a user's deletion or destruction.

# line 9:
# A single ActiveRecord callback is forgivable, but once you have multiple callbacks chained together, you should refactor your user creation process into its own class.

# line 11:
# These attributes need further validation of length, formatting, and character restrictions.

# line 14:
# The interpolated date calculation is interpreted only once (when your app loads), not when User.recently_created is called. Wrap your chained scope parameters in a lambda.

# line 17:
# self.attribute is unnecessary except when assigning. Also, use .join() for string concatenation.

# line 21:
# This is purely presentational and belongs in a view helper. Also, use some other string delimiter if your string includes a bunch of double quotes.

# line 25:
# Here, referral_code = should be self.referral_code = since you want to assign a value to it. This code does not ensure uniqueness of the referral code as specified in the validations, either.

# line 28:
# Methods not relating to the User model as a domain model probably don't belong here.

# line 29:
# If you're using key-value storage like Redis for scheduled jobs, pass IDs of elements as your parameters, not entire elements.

# line 32:
# Instance methods that return true or false should end in ? per convention.

# line 37:
# This violates the Law of Demeter, in addition to being a completely silly method.

# line 41:
# First, use = for assignment and == for equality comparison. Second, or is a control flow operator and you want ||, the logical operator. Finally, use an authorization library like CanCan instead of hard-coding these emails.

# line 44:
# This method does not relate to the User domain model, so it doesn't belong in the User class.

# line 45:
# Assignment of the local variable result is unnecessary if only used for the subsequent if statement.

# line 47:
# Favor a "tell, don't ask" architecture when thinking about control flow.

# line 48:
# If a model's method is interacting with instances of several other models, it should be refactored into its own class for ease of testing with mocks/stubs.

# line 49:
# Your model shouldn't know or care about sending emails, which is yet another reason to extract this entire method.

# line 50:
# Using the explicit return is unnecessary unless you are trying to alter the method's control flow.

# line 57:
# ActiveRecord provides methods for destroying and deleting records. Use them. Destructive methods should, by convention, end in bang (!).

# line 59:
# Dynamic .find_by_ methods are deprecated. Use .find(&hellip;) or .where(&hellip;).first instead.

# line 61:
# Never rescue from Ruby's base Exception class. Rescue from StandardError or some more specific exception you're anticipating.

# line 62:
# You captured an exception but aren't re-raising any exception. What should this method return in the case of success? Failure?

# line 73:
# Just an aside, but you probably want an index on this column.

# line 76:
# Another aside: If this attribute is always set before creation, shouldn't it be not null as well?

# http://dmcca.be/2014/02/02/the-value-of-rails-worst-practices.html
# https://github.com/dpmccabe/rails-worst-practices/blob/master/user.rb
