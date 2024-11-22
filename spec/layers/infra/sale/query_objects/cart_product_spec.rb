require 'rails_helper'

RSpec.describe Infra::Sale::QueryObjects::CartProduct, type: :model do
  let(:cart) { create(:cart) }
  let(:product_1) { create(:product, price: 10.0) }
  let(:product_2) { create(:product, price: 20.0) }
  let!(:cart_product_1) { create(:cart_product, cart: cart, product: product_1, quantity: 2) }
  let!(:cart_product_2) { create(:cart_product, cart: cart, product: product_2, quantity: 3) }

  describe '#cart_total_price' do
    it 'calculates the total price of the cart products' do
      filter = OpenStruct.new(cart_id: cart.id)
      query_object = described_class.new(filter)

      expect(query_object.cart_total_price).to eq(80.0)
    end
  end
end
