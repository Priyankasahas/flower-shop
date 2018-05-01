require 'ostruct'

# Flower shop order processor
class OrderProcessor
  def self.process!(bundle_code, quantity)
    @bundles = CatalogueBundle.all_bundles_by_code(bundle_code)
    split_bundles(quantity, @bundles.map(&:quantity))
  end

  def self.split_bundles(quantity, available_bundle_quantities)
    cat_q = available_bundle_quantities
    @result = []

    while !cat_q.empty? || quantity != 0
      x = cat_q.last

      if quantity >= x
        processed_result = process(quantity, x, cat_q)
        quantity = processed_result.quantity
        break if processed_result.error
      else
        cat_q.pop
      end
    end
    processed_result
  end

  def self.process(quantity, x, cat_q)
    quantity = create_all_possible_bundles(quantity, x)
    cat_q.pop if quantity < x

    return OpenStruct.new(quantity: quantity,
                          result: @result,
                          error: 'Invalid quantity') if
                          cat_q.empty? && quantity != 0

    unless remainder_is_multiple_of_quantities(cat_q, quantity) || quantity == 0
      quantity = unbundle(quantity, x)
    end
    OpenStruct.new(quantity: quantity, result: @result, error: nil)
  end

  def self.create_all_possible_bundles(quantity, x)
    quantity = bundle(quantity, x) while quantity >= x
    quantity
  end

  def self.remainder_is_multiple_of_quantities(quantities, r)
    quantities.collect { |q| r % q }.include? 0
  end

  def self.bundle(quantity, x)
    selected_bundle = @bundles.find { |b| b.quantity == x }
    @result << OpenStruct.new(code: selected_bundle.code,
                              quantity: x,
                              price: selected_bundle.price)
    quantity - x
  end

  def self.unbundle(quantity, x)
    @result.pop
    quantity + x
  end
  private_class_method :split_bundles, :process, :create_all_possible_bundles
  private_class_method :remainder_is_multiple_of_quantities, :bundle, :unbundle
end
