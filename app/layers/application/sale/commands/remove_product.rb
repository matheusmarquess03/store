# frozen_string_literal: true
module Application
  module Sale
    module Commands
      class RemoveProduct

        # dto { id, product_id }
        def initialize(dto, klasses = {})
          @response_class             = klasses.fetch(:response_class) { Application::Response }
          @cart_repository            = klasses.fetch(:cart_repository) { Infra::Sale::Repositories::CartRepository.new }
          @product_repository         = klasses.fetch(:product_repository) { Infra::Sale::Repositories::ProductRepository.new }
          @cart_product_repository    = klasses.fetch(:cart_product_repository) { Infra::Sale::Repositories::CartProductRepository.new }
          @cart_product_filter        = klasses.fetch(:cart_product_filter) { Application::Sale::Queries::CartProductFilter }
          @cart_product_query_object  = klasses.fetch(:cart_product_query_object) { Infra::Sale::QueryObjects::CartProduct }
          @dto                        = dto
        end

        def call
          cart = find_cart
          return response_error('Cart not found.') unless cart

          product = find_product
          return response_error("Product not found.") unless product

          cart_product = find_cart_product(cart, product)
          return response_error("Product not found in cart.") unless cart_product

          remove_product_from_cart(cart_product)
          cart.update_total_price

          if cart.cart_products.empty?
            message = "Your cart is empty after removing the product."
            cart_response = build_cart_response(cart, message)
          else
            cart_response = build_cart_response(cart, "Product removed successfully.")
          end

          response_class.new(
            success: true,
            message: "Product removed successfully.",
            cart: cart_response
          )
        rescue StandardError => e
          response_error(e.message)
        end

        private

        attr_reader :dto, :cart_repository, :cart_product_repository, :response_class,
                    :product_repository, :cart_product_filter, :cart_product_query_object

        def find_cart
          cart_repository.find_by(id: dto.id)
        end

        def find_product
          product_repository.find_by(id: dto.product_id)
        end

        def find_cart_product(cart, product)
          cart_product_repository.find_by(product_id: product.id, cart_id: cart.id)
        end

        def remove_product_from_cart(cart_product)
          cart_product.destroy
        end

        def build_cart_response(cart, message)
          filter = cart_product_filter.new(cart_id: cart.id)
          total_price = cart_product_query_object.new(filter).cart_total_price

          {
            id: cart.id,
            products: cart.cart_products.map do |cart_product|
              {
                id: cart_product.product.id,
                name: cart_product.product.name,
                quantity: cart_product.quantity,
                unit_price: cart_product.product.price,
                total_price: cart_product.total_price
              }
            end,
            total_price: total_price,
            message: message
          }
        end

        def response_error(message)
          response_class.new(success: false, message: message)
        end
      end
    end
  end
end
