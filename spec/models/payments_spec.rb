# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments, type: :model do
  let(:processor) { Class.new }

  before do
    Payments.configure do |config|
      config.processors['test_method'] = processor
    end
  end

  after do
    Payments.configure do |config|
      config.processors = {}
    end
  end

  describe '.for' do
    context 'when processor is registred' do
      it 'returns the registred processor' do
        expect(Payments.for('test_method')).to be processor
      end
    end

    context 'when processor is not registred' do
      it 'raises a ProcessorNotFoundError' do
        expect { Payments.for('unregistred_processor') }.to raise_error(Payments::ProcessorNotFoundError)
      end
    end
  end

  describe '.method_names' do
    it 'returns the list of all registred processors' do
      expect(Payments.method_names).to contain_exactly('test_method')
    end
  end
end
