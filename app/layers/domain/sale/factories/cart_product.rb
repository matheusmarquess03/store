module Domain
  module Sale
    module Factories::CartProduct
      class << self
        def build(dto)
          initialize_cart_product(dto)
        end

        private

        def initialize_cart_product(dto)
          Domain::Sale::CartProduct.new(dto.marshal_dump)
        end
      end
    end
  end
end
