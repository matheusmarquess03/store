# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Application::Sale::Commands::CreateCart, type: :class do
  describe '.call' do
    subject do
      described_class.new(dto, {
        response_class: response_class,
        cart_factory: cart_factory,
        cart_repository: cart_repository,
        product_repository: product_repository,
        cart_product_repository: cart_product_repository,
        cart_product_filter: cart_product_filter,
        cart_product_query_object: cart_product_query_object
      }).call
    end

    let(:response_class) { Application::Response }
    let(:cart_factory) { class_double(Domain::Sale::Factories::Cart) }
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
      allow(cart_product_repository).to receive(:find_or_initialize_by).and_return(cart_product)
      allow(cart_product_query_object).to receive(:new).and_return(double(cart_total_price: 100))
      allow(cart_product_repository).to receive(:save!).and_return(cart_product)

      allow(cart_repository).to receive(:save!).with(cart).and_return(cart)

      allow(cart_factory).to receive(:build).and_return(cart)
    end

    context 'when the cart is created successfully' do
      it 'returns a success response with cart details' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.message).to eq("Created successfully!")
        expect(result.cart[:id]).to eq(cart.id)
        expect(result.cart[:total_price]).to be_present
      end
    end

    context 'when ActiveRecord::RecordInvalid is raised' do
      before do
        allow(cart_product_repository).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(cart))
        allow(cart).to receive(:errors).and_return(double("errors", full_messages: ["Invalid Cart"]))
      end

      it 'returns an error response with validation messages' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq(cart.errors)
      end
    end

    context 'when the cart does not exist and a new cart is created' do
      before do
        allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(nil)
        allow(cart_factory).to receive(:build).with(dto).and_return(cart)
      end

      it 'returns a success response and creates a new cart' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.message).to eq("Created successfully!")
        expect(result.cart[:id]).to eq(cart.id)
      end
    end
  end
end
