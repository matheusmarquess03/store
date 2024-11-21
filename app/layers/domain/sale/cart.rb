module Domain
  module Sale
    class Cart < ::Cart
      has_many :cart_products
      has_many :products, through: :cart_products
      validates_numericality_of :total_price, greater_than_or_equal_to: 0

      before_save :update_total_price
      before_save :update_last_activity_at

      def update_total_price
        self.total_price = cart_products.sum { |cp| cp.quantity * cp.product.price }
      end

      private
      def update_last_activity_at
        self.last_activity_at = Time.current
      end
    end
  end
end
