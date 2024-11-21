class AddLastActivityAndAbandonedToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_activity_at, :datetime
    add_column :carts, :abandoned, :boolean
  end
end
