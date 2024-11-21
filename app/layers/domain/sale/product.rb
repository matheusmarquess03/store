module Domain
  module Sale
    class Product < ::Product
      has_many :cart_products
      has_many :carts, through: :cart_products

      validates_presence_of :name, :price
      validates_numericality_of :price, greater_than_or_equal_to: 0
    end
  end
end
