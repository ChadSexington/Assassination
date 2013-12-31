class AddConfirmedToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :confirmed, :boolean, :default => false
  end
end
