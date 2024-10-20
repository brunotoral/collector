# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processor, type: :model do
  let!(:processor) do
    TestProcessor = Class.new do
      include Payments::Processor

      def process
        'Processed!'
      end
    end
  end
  describe '#process' do
    context 'when processor does not implement the process method' do
      it 'raises a NotImplementedError' do
        processor_class = Class.new { include Payments::Processor }

        expect { processor_class.new.process }.to raise_error(NotImplementedError)
      end
    end

    context 'when processor implements the process method' do
      it "calls the processor's process method" do
        expect(processor.new.process).to be 'Processed!'
      end
    end
  end
end
