require 'shop'

# Ordering Tool
class OrderingTool
  def self.start!
    orders = Shop.input!

    Shop.process!(orders)
  end
end
