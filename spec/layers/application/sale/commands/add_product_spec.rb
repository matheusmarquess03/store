require 'rails_helper'

RSpec.describe Application::Sale::Commands::AddProduct, type: :class do
  describe '.call' do
    subject do
      described_class.new(dto, {
        cart_repository: cart_repository,
        product_repository: product_repository,
        cart_product_repository: cart_product_repository,
        cart_product_filter: cart_product_filter,
        cart_product_query_object: cart_product_query_object,
        response_class: response_class
      }).call
    end

    let(:response_class) { Application::Response }
    let(:cart_repository) { instance_double(Infra::Sale::Repositories::CartRepository) }
    let(:product_repository) { instance_double(Infra::Sale::Repositories::ProductRepository) }
    let(:cart_product_repository) { instance_double(Infra::Sale::Repositories::CartProductRepository) }
    let(:cart_product_filter) { class_double(Application::Sale::Queries::CartProductFilter) }
    let(:cart_product_query_object) { class_double(Infra::Sale::QueryObjects::CartProduct) }
    let(:dto) { double(id: cart.id, product_id: product.id, quantity: 2) }
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let(:cart_product) { create(:cart_product, cart: cart, product: product) }

    before do
      allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(cart)
      allow(product_repository).to receive(:find_by).with(id: dto.product_id).and_return(product)
      allow(cart_product_filter).to receive(:new).with(cart_id: cart.id).and_return(double)
      allow(cart_product_query_object).to receive(:new).and_return(double(cart_total_price: 100))

      allow(cart_product_repository).to receive(:save!).and_return(cart_product)
    end

    context 'when the cart exists and the product is added' do
      let!(:cart_product) { create(:cart_product, cart: cart, product: product) }

      it 'returns a success response with updated cart details' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.message).to eq("Product added successfully.")
        expect(result.cart[:total_price]).to eq(100)
      end
    end

    context 'when the cart does not exist' do
      before do
        allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(nil)
      end

      it 'returns an error response with "Cart not found."' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq("Cart not found.")
      end
    end

    context 'when the product cannot be found' do
      before do
        allow(cart_repository).to receive(:find_by).and_return(nil)
      end

      it 'returns an error response with "Cart not found."' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq("Cart not found.")
      end
    end

    context 'when ActiveRecord::RecordInvalid is raised' do
      let!(:cart) { create(:cart) }
      let(:errors) { double("errors") }

      before do
        allow(cart_product_repository).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(cart))
        allow(cart).to receive(:errors).and_return(errors)
      end

      it 'returns an error response with validation messages' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq(cart.errors)
      end
    end
  end
end
