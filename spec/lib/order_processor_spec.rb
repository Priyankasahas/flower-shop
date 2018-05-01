require 'spec_helper'
require 'order_processor'

RSpec.describe OrderProcessor do
  context '.process!' do
    let(:bundle_code) { 'T58' }

    let(:catalogue_bundle_model) { class_double('CatalogueBundle').as_stubbed_const }
    let(:catalogue_bundles) { [OpenStruct.new(name: 'Tulips',
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

    before do
      expect(catalogue_bundle_model).to receive(:all_bundles_by_code) { catalogue_bundles }
    end

    subject { OrderProcessor.process!(bundle_code, quantity) }

    context 'with valid quantity' do
      let(:quantity) { 13 }
      let(:results) {  [OpenStruct.new(code: 'T58',
                                       quantity: 5,
                                       price: 9.95),
                        OpenStruct.new(code: 'T58',
                                       quantity: 5,
                                       price: 9.95),
                        OpenStruct.new(code: 'T58',
                                       quantity: 3,
                                       price: 5.95)]
                    }

      it 'should return an object with no error, quantity being 0 and has results array' do
        expect(subject).to eq(OpenStruct.new(quantity: 0, result: results, error: nil))
      end
    end

    context 'with invalid quantity' do
      let(:quantity) { 7 }
      let(:results) { [OpenStruct.new(code: 'T58',
                                     quantity: 3,
                                     price: 5.95),
                       OpenStruct.new(code: 'T58',
                                      quantity: 3,
                                      price: 5.95)] }
      it 'should return an object with error, remaining quantity and bundled incomplete results' do
        expect(subject).to eq(OpenStruct.new(quantity: 1, result: results, error: 'Invalid quantity'))
      end
    end
  end
end
