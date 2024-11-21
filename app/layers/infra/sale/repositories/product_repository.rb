module Infra
  module Sale::Repositories
    class ProductRepository
      def initialize(model = {})
        @model = model.fetch(:product_model) { Domain::Sale::Product }
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

      def find_by_id(attribute)
        model.find(attribute)
      end

      def update(products, attributes)
        products.update(attributes)
      end

      def update_all(products, attributes)
        products.in_batches.update_all(attributes)
      end

      private

      attr_reader :model
    end
  end
end
