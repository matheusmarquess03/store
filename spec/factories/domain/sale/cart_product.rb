FactoryBot.define do
  factory :cart_product, class: Domain::Sale::CartProduct do
    quantity { 1 }
    cart
    product
  end
end
