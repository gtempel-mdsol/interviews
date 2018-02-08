# programming exercise: refactor

class Coffee
   def cost
    2
  end
end

class CoffeeWithMilk < Coffee
  def cost
    super + 0.4
  end
end

class CoffeeWithSugar < Coffee
  def cost
    super + 0.2
  end
end

class CoffeeWithMilkAndSugar < Coffee
  def cost
    super + 0.4 + 0.2
  end
end

# problems with this inheritance:
# choices are made statically
# tight coupling
# changing internals of super means changes to all subclasses
# are they really different types of coffee?
# what about coffee with cream? mocha? caramel?

# how about composition?

# could make milk, sugar, etc modules, and then include them
# if we were extracting methods, we could perhaps group them into
# an ActiveSupport::Concern, which could then be include'd like modules


module Milk
  def cost
    super + 0.4
  end
end

module Sugar
  def cost
    super + 0.2 
  end
end

class Coffee
  def cost
    2.0
  end
end

# still really inheriting
# can we have coffee without milk? without sugar?

c = Coffee.new
c.extend(Milk)
c.cost
c.extend(Sugar)
c.cost

# can we add extra sugar?
c.extend(Sugar)
c.cost

# no, we can't. So how about composition via decorators instead of mixing-in via modules?

class Coffee
  def initialize
    # 
    @hot = 3
  end

  def hot?
    if @hot > 0
      @hot -= 1
      'yes'
    else
      'no'
    end
  end

  def cost
    2.0
  end
end

class CoffeeDecorator < SimpleDelegator
  def initialize(coffee)
    @coffee = coffee
    super
  end
end

class MilkDecorator < CoffeeDecorator
  def cost
    super + 0.4
  end
end

class SugarDecorator < CoffeeDecorator
  def cost
    super + 0.2
  end
end

# this allows us to keep wrapping/combining
c = SugarDecorator.new(SugarDecorator.new(Coffee.new))
c.cost

