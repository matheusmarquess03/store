module Infra
  module Sale::QueryObjects
    class CartProduct
      def initialize(filter, klasses = {})
        @filter             = filter
        @cart_product_model = klasses.fetch(:cart_product_model) { Domain::Sale::CartProduct }
      end

      def cart_total_price
        query
      end

      private

      attr_reader :filter, :cart_product_model

      def query
        cart_product_model.joins(:product)
                          .where(cart_id: filter.cart_id)
                          .sum("cart_products.quantity * products.price")

      end
    end
  end
end
