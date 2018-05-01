require 'ostruct'
# Order Receipt generator
class OrderReceipt
  def self.generate!(result_bundles, code)
    receipt = OpenStruct.new
    receipt.text = ''
    receipt.total_price = 0

    result_bundles.each do |bundle|
      receipt.text += "#{bundle.quantity} #{code} X $#{bundle.price}\n"
      receipt.total_price += (bundle.quantity * bundle.price)
    end
    receipt
  end
end
