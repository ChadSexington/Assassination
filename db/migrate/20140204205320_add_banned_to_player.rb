class AddBannedToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :banned, :boolean, :default => false
  end
end
