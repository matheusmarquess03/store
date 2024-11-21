# frozen_string_literal: true

module Application
  module Sale
    module Commands
      class AddProduct

        # dto { id, product_id, quantity }
        def initialize(dto, klasses = {})
          @response_class           = klasses.fetch(:response_class) { Application::Response }
          @cart_repository          = klasses.fetch(:cart_repository) { Infra::Sale::Repositories::CartRepository.new }
          @product_repository       = klasses.fetch(:product_repository) { Infra::Sale::Repositories::ProductRepository.new }
          @cart_product_repository  = klasses.fetch(:cart_product_repository) { Infra::Sale::Repositories::CartProductRepository.new }
          @cart_product_filter      = klasses.fetch(:cart_product_filter) { Application::Sale::Queries::CartProductFilter }
          @cart_product_query_object  = klasses.fetch(:cart_product_query_object) { Infra::Sale::QueryObjects::CartProduct }
          @dto                      = dto
        end

        def call
          cart = cart_repository.find_by(id: dto.id)

          return response_error("Cart not found.") unless cart

          add_product_to_cart(cart)

          response_class.new(
            success: true,
            message: "Product added successfully.",
            cart: build_cart_response(cart)
          )
        rescue ActiveRecord::RecordInvalid => e
          response_error(cart.errors)
        end

        private

        attr_reader :dto, :cart_factory, :cart_repository, :response_class, :product_repository,
                    :cart_product_repository, :cart_product_filter, :cart_product_query_object

        def build_cart_response(cart)
          {
            id: cart.id,
            products: cart.cart_products.map do |cart_product|
              product = cart_product.product
              {
                id: product.id,
                name: product.name,
                quantity: cart_product.quantity,
                unit_price: product.price,
                total_price: cart_product.quantity * product.price
              }
            end,
            total_price: fetch_full_price(cart)
          }
        end

        def fetch_full_price(cart)
          filter = cart_product_filter.new(cart_id: cart.id)
          cart_product_query_object.new(filter).cart_total_price
        end

        def add_product_to_cart(cart)
          product = product_repository.find_by_id(dto.product_id)
          return unless product

          cart_product = cart.cart_products.find_or_initialize_by(product_id: product.id)

          if cart_product.persisted?
            cart_product.increment!(:quantity, dto.quantity.to_i)
          else
            cart_product.assign_attributes(quantity: dto.quantity.to_i)
            cart_product.cart = cart
          end

          cart_product_repository.save!(cart_product)
        end

        def response_error(message)
          response_class.new(success: false, message: message)
        end
      end
    end
  end
end
