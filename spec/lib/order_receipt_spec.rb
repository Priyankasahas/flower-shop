require 'spec_helper'
require 'order_receipt'

RSpec.describe OrderReceipt do
  context '.generate!' do
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

    subject { OrderReceipt.generate!(results, 'T58') }

    it 'should return a receipt with text' do
      expect(subject.text).to eq "5 T58 X $9.95\n5 T58 X $9.95\n3 T58 X $5.95\n"
    end

    it 'should return a receipt with total price' do
      expect(subject.total_price).to eq 117.35
    end
  end
end
