require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let!(:product) { create(:product) } # Cria um produto usando FactoryBot
  let(:valid_attributes) { { name: 'New Product', price: 100.0 } }
  let(:invalid_attributes) { { name: '', price: nil } }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns all products as JSON' do
      get :index
      expect(JSON.parse(response.body).size).to eq(Product.count)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response for an existing product' do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct product as JSON' do
      get :show, params: { id: product.id }
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(product.id)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { product: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new product' do
        expect {
          post :create, params: { product: invalid_attributes }
        }.not_to change(Product, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid attributes' do
      it 'updates the product' do
        patch :update, params: { id: product.id, product: { name: 'Updated Product' } }
        product.reload
        expect(product.name).to eq('Updated Product')
      end

      it 'returns a successful response' do
        patch :update, params: { id: product.id, product: { name: 'Updated Product' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the product' do
        patch :update, params: { id: product.id, product: { name: '' } }
        product.reload
        expect(product.name).not_to eq('')
      end

      it 'returns an unprocessable entity status' do
        patch :update, params: { id: product.id, product: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it 'returns a no content status' do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
