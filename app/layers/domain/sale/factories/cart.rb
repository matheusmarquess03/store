module Domain
  module Sale
    module Factories::Cart
      class << self
        def build(dto)
          find_or_initialize_cart(dto)
        end

        private

        def find_or_initialize_cart(dto)
          model = Domain::Sale::Cart
          return model.create if dto.id.nil?

        end
      end
    end
  end
end
