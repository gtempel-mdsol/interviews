# includes_and_joins:
#
# programming interview question to explore active record understanding
# https://mdsol.jiveon.com/docs/DOC-7392

# given that you have these models (details left out)
class User < ActiveRecord::Base        
  has_many :addresses  
  has_many :orders  
end  
  
class Address  
  belongs_to :User          
end  
  
class Order  
  belongs_to :User  
  has_many :order_items  
end  
  
class OrderItem  
  belongs_to :order    
end


# 1: write an active record query to find all users living in New York state
# users = User.joins(:addresses).where(addresses: {state: 'NY'})

# 2: write an active record query to find all users who ordered the 'Ruby on Rails' book
User.joins(:orders).merge(Order.joins(:order_items).where(order_items: {description: 'Ruby on Rails'}))
# SELECT "users".* FROM "users" INNER JOIN "orders" ON "orders"."user_id" = "users"."id" 
#   LEFT OUTER JOIN "order_items" ON "order_items"."order_id" = "orders"."id" WHERE "order_items"."description" = ?  [["description", "dog toy"]]
# or...
# add a has_many :order_items, :through => :order to User, then can do
# User.joins(:order_items).where(order_items: {description: 'Ruby on Rails'})

# 3: find users who do not have any order
# could use:
# users = User.includes(:orders).where(orders: {id: nil})
# or if Rails 5
# users = User.left_outer_joins(:orders).where(orders: {id: nil})


# 4: what's the difference between includes (:include foo) and joins?
# the joins joins tables together in sql, but doesn't actually return the joined info
# directly, instead returning a proxy that will be used to do the actual fetch. This
# can lead to an n+1 query scenario (1 query for everything, then 1 for each subsequent)
# fetch of the association info). 
#
# users = User.joins(:address)  -- uses an inner join
# returns all users who have an address, but not their actual addresses. users[0].address
# will perform another query, leading to the n+1 problem
#
# users = User.includes(:address)  -- uses an outer join
# returns all users, address or no, and users[0].address won't issue another query
#
# users = User.includes(:address).joins(:address)
# returns all users with an address, and users[0].address won't issue another query, but
# works better for has_one relationships than has_many