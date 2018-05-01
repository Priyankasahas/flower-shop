require 'shop'

class OrderingTool
  def self.start!
    orders = Shop.input!    

    Shop.process!(orders)
  end
end
