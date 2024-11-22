# spec/factories/carts.rb

FactoryBot.define do
  factory :cart, class: Domain::Sale::Cart do
    total_price { 100.0 }
    abandoned { false }
    last_activity_at { 1.hours.ago }

    # after(:create) do |cart|
    #   create_list(:cart_product, 3, cart: cart)
    # end
  end
end
