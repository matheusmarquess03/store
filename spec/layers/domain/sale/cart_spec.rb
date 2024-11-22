require 'rails_helper'

RSpec.describe Domain::Sale::Cart, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:cart) { create(:cart) }
  let(:product_1) { create(:product, price: 10.0) }
  let(:product_2) { create(:product, price: 20.0) }
  let!(:cart_product_1) { create(:cart_product, cart: cart, product: product_1, quantity: 2) }
  let!(:cart_product_2) { create(:cart_product, cart: cart, product: product_2, quantity: 3) }

  describe 'validations' do
    it 'validates numericality of total_price' do
      cart.total_price = -1
      expect(cart).not_to be_valid
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'callbacks' do
    it 'updates total_price before save' do
      cart.cart_products.build(product: product_1, quantity: 2)
      cart.cart_products.build(product: product_2, quantity: 1)

      cart.save

      expect(cart.total_price).to eq(40.0)
    end

    it 'updates last_activity_at before save' do
      initial_time = cart.last_activity_at
      travel_to Time.current + 1.hour do
        cart.save
        expect(cart.last_activity_at).to be > initial_time
      end
    end
  end

  describe 'associations' do
    it 'has many cart_products' do
      expect(cart.cart_products.count).to eq(2)
    end

    it 'has many products through cart_products' do
      product_ids = cart.products.pluck(:id)
      expect(product_ids).to include(product_1.id, product_2.id)
    end
  end
end
