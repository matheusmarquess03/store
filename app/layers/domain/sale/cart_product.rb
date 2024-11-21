module Domain
  module Sale
    class CartProduct < ::CartProduct
      belongs_to :cart
      belongs_to :product

      validates :quantity, numericality: { greater_than_or_equal_to: 1 }

      def total_price
        quantity * product.price
      end
    end
  end
end
