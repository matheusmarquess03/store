FactoryBot.define do
  factory :product, class: Domain::Sale::Product do
    name { "Example Product" }
    price { 100.0 }
  end
end
