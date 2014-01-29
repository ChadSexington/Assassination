class AddKdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :kills, :int
    add_column :players, :deaths, :int
  end
end
