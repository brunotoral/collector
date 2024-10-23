# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Processor, type: :model do
  let!(:processor) do
    TestProcessor = Class.new do
      include Payments::Processor

      def charge(invoice)
        "Processed! #{invoice}"
      end

      def subscribe
        "Subscribed!"
      end
    end
  end

  describe '#charge' do
    context 'when processor does not implement the charge method' do
      it 'raises a NotImplementedError' do
        processor_class = Class.new { include Payments::Processor }

        expect { processor_class.new.charge('invoice') }.to raise_error(NotImplementedError)
      end
    end

    context 'when processor implements the charge method' do
      it "calls the processor's charge method" do
        expect(processor.new.charge('invoice')).to eq 'Processed! invoice'
      end
    end
  end

  describe '#subscribe' do
    context 'when processor does not implement the subscribe method' do
      it 'raises a NotImplementedError' do
        processor_class = Class.new { include Payments::Processor }

        expect { processor_class.new.subscribe }.to raise_error(NotImplementedError)
      end
    end

    context 'when processor implements the subscribe method' do
      it "calls the processor's subscribe method" do
        expect(processor.new.subscribe).to eq 'Subscribed!'
      end
    end
  end
end
