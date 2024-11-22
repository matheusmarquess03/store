require 'rails_helper'

describe Application::Sale::Commands::ListProduct, type: :class do
  describe '.call' do
    subject do
      described_class.new(dto, {
        cart_repository: cart_repository,
        cart_product_repository: cart_product_repository,
        cart_product_filter: cart_product_filter,
        cart_product_query_object: cart_product_query_object,
        response_class: response_class
      }).call
    end

    let(:response_class) { Application::Response }
    let(:cart_repository) { instance_double(Infra::Sale::Repositories::CartRepository) }
    let(:cart_product_repository) { instance_double(Infra::Sale::Repositories::CartProductRepository) }
    let(:cart_product_filter) { class_double(Application::Sale::Queries::CartProductFilter) }
    let(:cart_product_query_object) { class_double(Infra::Sale::QueryObjects::CartProduct) }
    let(:dto) do
      double(id: cart.id)
    end
    let(:cart) { create(:cart) }
    let(:product) { create(:product) }
    let!(:cart_product) { create(:cart_product, cart: cart, product: product) }

    before do
      allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(cart)
      allow(cart_product_filter).to receive(:new).with(cart_id: cart.id).and_return(double)
      allow(cart_product_query_object).to receive(:new).and_return(double(cart_total_price: 100))
      allow(cart.cart_products).to receive(:map).and_return([double(product: double(id: 1, name: 'Product 1', price: 10), quantity: 2)])
      allow(cart_product).to receive(:product).and_return(product)
      allow(cart.cart_products).to receive(:map).and_return([{
                                                               id: product.id,
                                                               name: product.name,
                                                               quantity: cart_product.quantity,
                                                               unit_price: product.price,
                                                               total_price: cart_product.quantity * product.price
                                                             }])
    end

    context 'when the cart exists' do
      it 'returns a success response with cart details' do
        result = subject

        expect(result.success).to eq(true)
        expect(result.message).to eq('Cart displayed successfully.')
        expect(result.cart).to include(:id, :products, :total_price)
        expect(result.cart[:products].first).to include(:id, :name, :quantity, :unit_price, :total_price)
      end
    end

    context 'when the cart is not found' do
      before do
        allow(cart_repository).to receive(:find_by).with(id: dto.id).and_return(nil)
      end

      it 'returns a response error' do
        result = subject

        expect(result.success).to eq(false)
        expect(result.message).to eq('Cart not found.')
      end
    end
  end
end
