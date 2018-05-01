require 'rails_helper'
require 'ordering_tool'

RSpec.describe 'OrderingTool' do
  context '.start!' do
    let(:cli_service) { class_double('CliService').as_stubbed_const }
    let(:cli_service_instance) { double }

    let(:valid_user_input) { ['5 R12', '3 T58'] }

    let(:invalid_user_input) { ['2 R12'] }
    let!(:roses_bundle) do
      create(:catalogue_bundle, name: 'Roses', code: 'R12', quantity: 5, price: 6.99)
    end

    let!(:tulips_bundle) do
      create(:catalogue_bundle, name: 'Tulips', code: 'T58', quantity: 3, price: 5.95)
    end

    subject { OrderingTool.start! }

    context 'with valid input' do
      before do
        expect(cli_service).to receive(:new) { cli_service_instance }
        expect(cli_service_instance).to receive(:get_input) { valid_user_input }
      end

      it 'should output processing of roses' do
        expect { subject }.to output(/Processing bundles for 5 Roses - R12.../).to_stdout
      end

      it 'should output processing of tulips' do
        expect { subject }.to output(/Processing bundles for 3 Tulips - T58.../).to_stdout
      end

      it 'should say Thank You!' do
        expect { subject }.to output(/Thank You!/).to_stdout
      end
    end

    context 'with invalid input' do
      before do
        expect(cli_service).to receive(:new) { cli_service_instance }
        expect(cli_service_instance).to receive(:get_input).exactly(4).times { invalid_user_input }
      end

      it 'should output an error' do
        expect(STDOUT).to receive(:puts).with("\e[31mInvalid entry 2 R12. Please try again..\e[0m").exactly(3).times
        expect(STDOUT).to receive(:puts).with("\e[31mInvalid entry 2 R12! Exiting...\e[0m").once
        subject
      end
    end
  end
end
