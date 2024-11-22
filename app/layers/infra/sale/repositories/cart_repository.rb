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

      private

      attr_reader :model
    end
  end
end
