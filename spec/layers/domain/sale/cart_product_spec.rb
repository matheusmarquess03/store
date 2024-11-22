require 'rails_helper'

RSpec.describe Domain::Sale::CartProduct, type: :model do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

  describe '#total_price' do
    let(:product) { create(:product, price: 100) }
    let(:cart) { create(:cart) }
    let(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 2) }

    it 'calculates the total price based on quantity and product price' do
      expect(cart_product.total_price).to eq(200)
    end
  end
end
