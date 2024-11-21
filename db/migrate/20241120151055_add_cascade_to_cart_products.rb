class AddCascadeToCartProducts < ActiveRecord::Migration[7.1]
  def change
    def change
      remove_foreign_key :cart_products, :carts

      add_foreign_key :cart_products, :carts, on_delete: :cascade
    end
  end
end
