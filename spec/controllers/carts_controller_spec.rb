require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:dto) { instance_double(Application::Response) }

  before do
    session[:cart_id] = cart.id
    allow(controller).to receive(:dto).and_return(dto)
  end

  describe "POST #create" do
    let(:response_mock) { double(Application::Response, success: success, cart: cart, message: message) }

    before do
      allow(::Application::Sale::Carts).to receive(:create_cart).and_return(response_mock)
    end

    context "when creation is successful" do
      let(:success) { true }
      let(:message) { nil }

      it "returns a successful response with the cart" do
        post :create, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('id' => cart.id)
      end
    end

    context "when creation fails" do
      let(:success) { false }
      let(:message) { "Failed to create cart" }

      it "returns an error response with the failure message" do
        post :create, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => message)
      end
    end
  end

  describe "POST #list_products" do
    let(:response_mock) { double(Application::Response, success: success, cart: cart, message: message) }

    before do
      allow(::Application::Sale::Carts).to receive(:list_product).and_return(response_mock)
    end

    context "when listing products is successful" do
      let(:success) { true }
      let(:message) { nil }

      it "returns a successful response with the cart" do
        post :list_products, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('id' => cart.id)
      end
    end

    context "when listing products fails" do
      let(:success) { false }
      let(:message) { "Failed to list products" }

      it "returns an error response with the failure message" do
        post :list_products, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => message)
      end
    end
  end

  describe "POST #add_item" do
    let(:response_mock) { double(Application::Response, success: success, cart: cart, message: message) }

    before do
      allow(::Application::Sale::Carts).to receive(:add_item).and_return(response_mock)
    end

    context "when adding item is successful" do
      let(:success) { true }
      let(:message) { nil }

      it "returns a successful response with the updated cart" do
        post :add_item, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('id' => cart.id)
      end
    end

    context "when adding item fails" do
      let(:success) { false }
      let(:message) { "Failed to add item" }

      it "returns an error response with the failure message" do
        post :add_item, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => message)
      end
    end
  end

  describe "POST #remove_item" do
    let(:response_mock) { double(Application::Response, success: success, cart: cart, message: message) }

    before do
      allow(::Application::Sale::Carts).to receive(:remove_item).and_return(response_mock)
    end

    context "when removing item is successful" do
      let(:success) { true }
      let(:message) { nil }

      it "returns a successful response with the updated cart" do
        post :remove_item, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('id' => cart.id)
      end
    end

    context "when removing item fails" do
      let(:success) { false }
      let(:message) { "Failed to remove item" }

      it "returns an error response with the failure message" do
        post :remove_item, params: { product_id: 1, quantity: 2 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('error' => message)
      end
    end
  end
end
