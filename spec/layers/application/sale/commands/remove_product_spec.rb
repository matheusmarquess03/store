# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Application::Sale::Commands::RemoveProduct, type: :class do
  describe '.call' do
    subject do
      described_class.new(dto, {
        response_class: response_class,
        cart_repository: cart_repository,
        product_repository: product_repository,
        cart_product_repository: cart_product_repository,
        cart_product_filter: cart_product_filter,
        cart_product_query_object: cart_product_query_object
      }).call
    end

    let(:response_class) { Application::Response }
    let(:cart_repository) { instance_double(Infra::Sale::Repositories::CartRepository) }
    let(:product_repository) { instance_double(Infra::Sale::Repositories::ProductRepository) }
    let(:cart_product_repository) { instance_double(Infra::Sale::Repositories::CartProductRepository) }
    let(:cart_product_filter) { class_double(Application::Sale::Queries::CartProductFilter) }
    let(:cart_product_query_object) { class_double(Infra::Sale::QueryObjects::CartProduct) }
    let(:dto) { double(id: cart.id, product_id: product.id) }
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let(:cart_product) { create(:cart_product, cart: cart, product: product) }

    before do
      allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(cart)
      allow(product_repository).to receive(:find_by).with(id: dto.product_id).and_return(product)
      allow(cart_product_repository).to receive(:find_by).with(product_id: product.id, cart_id: cart.id).and_return(cart_product)
      allow(cart_product).to receive(:destroy)
      allow(cart).to receive(:update_total_price)
      allow(cart_product_filter).to receive(:new).with(cart_id: cart.id).and_return(double)
      allow(cart_product_query_object).to receive(:new).and_return(double(cart_total_price: 100))
    end

    context 'when the product is successfully removed from the cart' do
      it 'returns a success response' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.message).to eq("Product removed successfully.")
        expect(result.cart[:id]).to eq(cart.id)
        expect(result.cart[:total_price]).to eq(100)
      end
    end

    context 'when the cart is not found' do
      before do
        allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(nil)
      end

      it 'returns an error response' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq('Cart not found.')
      end
    end

    context 'when the product is not found' do
      before do
        allow(product_repository).to receive(:find_by).with(id: dto.product_id).and_return(nil)
      end

      it 'returns an error response' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq("Product not found.")
      end
    end

    context 'when the product is not found in the cart' do
      before do
        allow(cart_product_repository).to receive(:find_by).with(product_id: product.id, cart_id: cart.id).and_return(nil)
      end

      it 'returns an error response' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq("Product not found in cart.")
      end
    end

    context 'when the cart becomes empty after removing the product' do
      before do
        allow(cart_product_repository).to receive(:find_by).with(product_id: product.id, cart_id: cart.id).and_return(cart_product)
        allow(cart).to receive(:cart_products).and_return([cart_product])
        allow(cart_product).to receive(:destroy)
        allow(cart).to receive(:cart_products).and_return([])
      end

      it 'returns a message indicating the cart is empty' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.cart[:message]).to eq("Your cart is empty after removing the product.")
      end
    end
  end
end
