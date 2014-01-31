class AddKdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :kills, :int, :default => 0
    add_column :players, :deaths, :int, :default => 0
  end
end
