require 'cli_service'
require 'order_processor'
require 'ostruct'

# Flower Shop
class Shop
  def self.input!
    cli_service = CliService.new
    i = 0
    valid = false

    until valid == true
      i += 1
      order_inputs = cli_service.get_input('Please input your order quantity'\
                                           ' and flower code:')

      @valid_flower_orders = []
      order_inputs.each do |order_input|
        valid = check_validity_and_return(i, order_input)
      end
    end
    construct_valid_order_input
  end

  def self.process!(orders)
    total_order_price = 0
    orders.each do |order|
      total_order_price = process_order(order, total_order_price)
    end
    final_output(total_order_price)
  end

  def self.check_validity_and_return(i, order_input)
    valid = check_validity(order_input)
    show_exit_message("Invalid entry #{order_input}! Exiting...") if
    i == 4 && !valid

    message = "Invalid entry #{order_input}. Please try again.."
    send_output(message, 'red') unless valid
    valid
  end

  def self.check_validity(order_input)
    order_split = order_input.split(' ')
    catalogue_bundles = CatalogueBundle
                        .all_bundles_by_code(order_split[1]) if
    order_split.length == 2

    valid = error_if_invalid(order_split, catalogue_bundles)
    return unless valid

    @valid_flower_orders << OpenStruct.new(quantity: order_split[0].to_i,
                                           code: order_split[1],
                                           flower: catalogue_bundles.first.name)
    valid
  end

  def self.error_if_invalid(order_split, catalogue_bundles)
    valid = order_split.length == 2 && !catalogue_bundles.empty?
    return false unless valid

    quantity = order_split[0].to_i
    minimun_quantity = catalogue_bundles.first.quantity
    !(quantity < minimun_quantity)
  end

  def self.construct_valid_order_input
    orders = []
    @valid_flower_orders.each do |o|
      order = OpenStruct.new(code: o.code, quantity: o.quantity,
                             flower: o.flower)
      message = "Processing bundles for #{order.quantity} " \
                "#{order.flower} - #{order.code}..."
      send_output(message, 'yellow')
      orders << order
    end
    orders
  end

  def self.process_order(order, total_order_price)
    processed_order = OrderProcessor.process!(order.code, order.quantity)
    if processed_order.error.nil?
      total_order_price = calculate_and_create_receipt(processed_order.result,
                                                       order.code,
                                                       total_order_price)
    else
      send_output(processed_order.error, 'red')
    end
    total_order_price
  end

  def self.calculate_and_create_receipt(result, code, total_order_price)
    receipt = OrderReceipt.generate!(result, code)
    total_order_price += receipt.total_price
    message = "#{receipt.text}" + 'Total: '\
    "$#{receipt.total_price}\n" + "---------------------\n"

    send_output(message, 'cyan')
    total_order_price
  end

  def self.final_output(total_order_price)
    message = "Total Order Price: $#{total_order_price}" if
    total_order_price > 0
    send_output(message, 'cyan')

    send_output("\nThank You!", 'blue')
  end

  def self.show_exit_message(message)
    send_output(message, 'red')
    exit
  end

  def self.send_output(message, colour)
    puts Rainbow(message).send(colour.to_sym)
  end
  private_class_method :check_validity_and_return, :check_validity
  private_class_method :process_order, :calculate_and_create_receipt
  private_class_method :error_if_invalid, :final_output, :send_output
  private_class_method :construct_valid_order_input, :show_exit_message
end
