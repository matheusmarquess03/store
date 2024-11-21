# frozen_string_literal: true

module Application
  module Sale
    module Queries
      class CartProductFilter
        attr_reader :cart_id, :product_id

        def initialize(cart_id: nil, product_id: nil)
          @cart_id = cart_id
          @product_id = product_id
        end
      end
    end
  end
end