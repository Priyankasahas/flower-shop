require 'shop'
require 'order_processor'
require 'rainbow'

namespace :flower_shop do
  desc 'Order Flower Bundles'
  task order: :environment do
    OrderingTool.start!
  end
end
