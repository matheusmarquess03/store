module Application
  module Sale
    class Carts
      #commands
      def self.create_cart(dto)
        Application::Sale::Commands::CreateCart.new(dto).call
      end

      def self.list_product(dto)
        Application::Sale::Commands::ListProduct.new(dto).call
      end

      def self.add_item(dto)
        Application::Sale::Commands::AddProduct.new(dto).call
      end

      def self.remove_item(dto)
        Application::Sale::Commands::RemoveProduct.new(dto).call
      end
    end
  end
end
