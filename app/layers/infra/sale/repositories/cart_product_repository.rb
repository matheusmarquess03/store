module Infra
  module Sale::Repositories
    class CartProductRepository
      def initialize(model = {})
        @model = model.fetch(:product_model) { Domain::Sale::CartProduct }
      end

      def save!(product)
        product.save!
      end

      def find_by(attribute)
        model.find_by(attribute)
      end

      def find_or_initialize_by(attribute)
        model.find_or_initialize_by(attribute)
      end

      private

      attr_reader :model
    end
  end
end
