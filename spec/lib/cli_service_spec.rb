require 'cli_service'

RSpec.describe CliService do
  let(:highline_instance) { double(:highline_instance) }
  let(:highline_class) { class_double('HighLine').as_stubbed_const }

  before do
    allow(highline_class).to receive(:new) { highline_instance }
  end

  subject { CliService.new.get_input(message) }

  context '.get_input' do
    context 'given a message' do
      let(:message) { 'Enter text:' }

      it 'should ask for an input' do
        expect(highline_instance).to receive(:ask)
        subject
      end
    end
  end
end
