require 'spec_helper'
require 'shop'

RSpec.describe Shop do
  context '.input' do
    let(:cli_service) { class_double('CliService').as_stubbed_const }
    let(:cli_service_instance) { double }
    let(:valid_user_input) { ['10 R12', '13 T58'] }
    let(:invalid_user_input) { ['123'] }
    let(:catalogue_bundle_model) { class_double('CatalogueBundle').as_stubbed_const }
    let(:t58_catalogue_bundles) { [OpenStruct.new(name: 'Tulips',
                                                  code: 'T58',
                                                  quantity: 3,
                                                  price: 5.95),
                                   OpenStruct.new(name: 'Tulips',
                                                  code: 'T58',
                                                  quantity: 5,
                                                  price: 9.95),
                                   OpenStruct.new(name: 'Tulips',
                                                  code: 'T58',
                                                  quantity: 9,
                                                  price: 16.99)]
                                }
    let(:r12_catalogue_bundles) { [OpenStruct.new(name: 'Roses',
                                                  code: 'R12',
                                                  quantity: 5,
                                                  price: 6.99),
                                   OpenStruct.new(name: 'Roses',
                                                  code: 'R12',
                                                  quantity: 10,
                                                  price: 12.99)]
                                }

    subject { Shop.input! }

    before do
      expect(cli_service).to receive(:new) { cli_service_instance }
    end

    context 'valid user input' do
      let(:expected_result) do
        [OpenStruct.new(code: 'R12', quantity: 10, flower: 'Roses'),
         OpenStruct.new(code: 'T58', quantity: 13, flower: 'Tulips')]
      end
      it 'should process the input and return an order object' do
        expect(cli_service_instance).to receive(:get_input) { valid_user_input }
        expect(catalogue_bundle_model).to receive(:all_bundles_by_code).with('R12') { r12_catalogue_bundles }
        expect(catalogue_bundle_model).to receive(:all_bundles_by_code).with('T58') { t58_catalogue_bundles }

        expect(subject).to eq expected_result
      end
    end

    context 'invalid user input' do
      it 'should return an error message' do
        expect(cli_service_instance).to receive(:get_input) { invalid_user_input }
        expect(catalogue_bundle_model).to_not receive(:all_bundles_by_code)
        expect(STDOUT).to receive(:puts).with("\e[31mInvalid entry 123. Please try again..\e[0m").exactly(3).times
        expect(STDOUT).to receive(:puts).with("\e[31mInvalid entry 123! Exiting...\e[0m").once
        subject
      end
    end
  end

  context '.process!' do
    let(:order_processor) { class_double('OrderProcessor').as_stubbed_const }
    let(:order_receipt) { class_double('OrderReceipt').as_stubbed_const }
    let(:orders) do
      [OpenStruct.new(code: 'R12', quantity: 10, flower: 'Roses'),
       OpenStruct.new(code: 'L09', quantity: 15, flower: 'Lilies'),
       OpenStruct.new(code: 'T58', quantity: 13, flower: 'Tulips')]
    end
    let(:code) { 'T58' }
    let(:quantity) { 13 }
    let(:good_result) { double }
    let(:bad_result) { double }
    let(:good_quantity_order) { OpenStruct.new(quantity: 0, result: good_result, error: nil) }
    let(:bad_quantity_order) { OpenStruct.new(quantity: 0, result: bad_result, error: 'ERROR!') }
    let(:receipt) { OpenStruct.new(text: "Product Description\n", total_price: 105.0) }

    subject { Shop.process!(orders) }

    context 'valid quantity order' do
      before do
        expect(order_processor).to receive(:process!) { good_quantity_order }.exactly(3).times
      end

      it 'should return the receipt' do
        expect(order_receipt).to receive(:generate!).with(good_quantity_order.result, 'R12') { receipt }
        expect(order_receipt).to receive(:generate!).with(good_quantity_order.result, 'L09') { receipt }
        expect(order_receipt).to receive(:generate!).with(good_quantity_order.result, 'T58') { receipt }
        expect(STDOUT).to receive(:puts).with("\e[36mProduct Description\nTotal: $105.0\n---------------------\n\e[0m").exactly(3).times
        expect(STDOUT).to receive(:puts).with("\e[36mTotal Order Price: $315.0\e[0m")
        expect(STDOUT).to receive(:puts).with("\e[34m\nThank You!\e[0m")
        subject
      end
    end

    context 'invalid quantity order' do
      let(:orders) do
        [OpenStruct.new(code: 'R12', quantity: 10, flower: 'Roses'),
         OpenStruct.new(code: 'L09', quantity: 2, flower: 'Lilies')]
      end
      before do
        expect(order_processor).to receive(:process!).with('R12', 10) { good_quantity_order }
        expect(order_processor).to receive(:process!).with('L09', 2) { bad_quantity_order }
      end

      it 'should not return the receipt but return error message' do
        expect(order_receipt).to receive(:generate!).with(good_result, 'R12').once {receipt}
        expect(STDOUT).to receive(:puts).with("\e[36mProduct Description\nTotal: $105.0\n---------------------\n\e[0m")
        expect(STDOUT).to receive(:puts).with("\e[36mTotal Order Price: $105.0\e[0m")
        expect(STDOUT).to receive(:puts).with("\e[31mERROR!\e[0m")
        expect(STDOUT).to receive(:puts).with("\e[34m\nThank You!\e[0m")

        subject
      end
    end
  end
end
