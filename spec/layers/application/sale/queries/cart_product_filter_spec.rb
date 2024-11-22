require 'rails_helper'

RSpec.describe Application::Sale::Queries::CartProductFilter do
  describe '#initialize' do
    context 'when initialized with cart_id and product_id' do
      let(:cart_id) { 1 }
      let(:product_id) { 2 }
      subject { described_class.new(cart_id: cart_id, product_id: product_id) }

      it 'sets the cart_id' do
        expect(subject.cart_id).to eq(cart_id)
      end

      it 'sets the product_id' do
        expect(subject.product_id).to eq(product_id)
      end
    end

    context 'when initialized without arguments' do
      subject { described_class.new }

      it 'sets cart_id to nil' do
        expect(subject.cart_id).to be_nil
      end

      it 'sets product_id to nil' do
        expect(subject.product_id).to be_nil
      end
    end
  end
end
