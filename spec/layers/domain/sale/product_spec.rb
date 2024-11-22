require 'rails_helper'

RSpec.describe Domain::Sale::Product, type: :model do
  let(:product) { create(:product, name: 'Product A', price: 10.0) }

  describe 'validations' do
    it 'is valid with a name and price' do
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product.name = nil
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      product.price = nil
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a price less than 0' do
      product.price = -1
      expect(product).not_to be_valid
      expect(product.errors[:price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'associations' do
    it 'has many cart_products' do
      expect(product.cart_products).to be_empty
    end

    it 'has many carts through cart_products' do
      expect(product.carts).to be_empty
    end
  end
end
