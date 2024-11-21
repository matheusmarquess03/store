class CartsController < ApplicationController
  before_action :set_cart, only: [:list_products, :add_item, :remove_item, :create]

  def create
    response = ::Application::Sale::Carts.create_cart(dto)
    if response.success
      render json: response.cart, status: :ok
    else
      render json: { error: response.message }, status: :unprocessable_entity
    end
  end

  def list_products
    response = ::Application::Sale::Carts.list_product(dto)

    if response.success
      render json: response.cart, status: :ok
    else
      render json: { error: response.message }, status: :unprocessable_entity
    end
  end

  def add_item
    response = ::Application::Sale::Carts.add_item(dto)

    if response.success
      render json: response.cart, status: :ok
    else
      render json: { error: response.message }, status: :unprocessable_entity
    end
  end

  def remove_item
    response = ::Application::Sale::Carts.remove_item(dto)

    if response.success
      render json: response.cart, status: :ok
    else
      render json: { error: response.message }, status: :not_found
    end
  end

  private

  def dto
    data = constraint_cart_params.merge(cart_params)
    Application::Response.new(data)
  end

  def constraint_cart_params
    { id: @cart.id }
  end

  def set_cart
    @cart = Domain::Sale::Cart.find_by(id: session[:cart_id]) || Domain::Sale::Cart.create
    session[:cart_id] = @cart.id
  end
  def cart_params
    params.permit(:product_id, :quantity)
  end
end
