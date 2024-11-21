module Domain
  module Sale
    module Factories::Product
      class << self
        def build(dto)
          initialize_product(dto)
        end

        private

        def initialize_product(dto)
          Domain::Sale::CartProduct.new(dto.marshal_dump)
        end
      end
    end
  end
end
