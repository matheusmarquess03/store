# frozen_string_literal: true
module Application
  module Sale
    module Commands
      class CreateCart

        # dto { id, product_id, quantity }
        def initialize(dto, klasses = {})
          @response_class             = klasses.fetch(:response_class) { Application::Response }
          @cart_factory               = klasses.fetch(:cart_factory) { Domain::Sale::Factories::Cart }
          @cart_repository            = klasses.fetch(:cart_repository) { Infra::Sale::Repositories::CartRepository.new }
          @product_repository         = klasses.fetch(:product_repository) { Infra::Sale::Repositories::ProductRepository.new }
          @cart_product_repository    = klasses.fetch(:cart_product_repository) { Infra::Sale::Repositories::CartProductRepository.new }
          @cart_product_filter        = klasses.fetch(:cart_product_filter) { Application::Sale::Queries::CartProductFilter }
          @cart_product_query_object  = klasses.fetch(:cart_product_query_object) { Infra::Sale::QueryObjects::CartProduct }
          @dto                        = dto
        end

        def call
          cart = find_or_initialize_cart
          product = fetch_product

          return response_error("The requested product was not found in the system. Please check and try again.") if product.nil?

          update_cart_product(cart, product)

          cart_repository.save!(cart)

          response_class.new(
            success: true,
            message: "Created successfully!",
            cart: build_cart_response(cart)
          )
        rescue ActiveRecord::RecordInvalid => e
          response_error(cart.errors)
        end

        private

        attr_reader :dto, :cart_factory, :cart_repository, :response_class, :product_repository,
                    :cart_product_repository, :cart_product_filter, :cart_product_query_object

        def fetch_full_price(cart)
          filter = cart_product_filter.new(cart_id: cart.id)
          cart_product_query_object.new(filter).cart_total_price
        end

        def update_cart_product(cart, product)
          cart_product = cart_product_repository.find_or_initialize_by(cart_id: cart.id, product_id: product.id)
          cart_product.quantity = cart_product.persisted? ? cart_product.quantity + dto.quantity : dto.quantity
          cart_product

          cart_product_repository.save!(cart_product)
          cart_product
        end

        def fetch_product
          product_repository.find_by(id: dto.product_id)
        end

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

        def find_or_initialize_cart
          cart_repository.find_by(id: dto.id) || cart_factory.build(dto)
        end
        def response_error(message)
          response_class.new(success: false, message: message)
        end
      end
    end
  end
end
