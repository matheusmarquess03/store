require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #list_products via GET' do
      expect(get: '/cart').to route_to('carts#list_products')
    end

    it 'routes to #create via POST' do
      expect(post: '/cart').to route_to('carts#create')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to('carts#add_item')
    end

    it 'routes to #remove_item via DELETE with product_id' do
      expect(delete: '/cart/1').to route_to(
                                     'carts#remove_item', product_id: '1'
                                   )
    end
  end
end
