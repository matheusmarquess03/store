module Infra
  module Sale::Repositories
    class CartRepository
      def initialize(model = {})
        @model = model.fetch(:cart_model) { Domain::Sale::Cart }
      end

      def save!(cart)
        cart.save!
      end

      def find_by(attribute)
        model.find_by(attribute)
      end

      def find_by_id(attribute)
        model.find(attribute)
      end

      def update(carts, attributes)
        carts.update(attributes)
      end

      def update_all(carts, attributes)
        carts.in_batches.update_all(attributes)
      end

      private

      attr_reader :model
    end
  end
end
