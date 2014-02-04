class RemoveKdFromPlayer < ActiveRecord::Migration
  def up
    remove_column :players, :kills
    remove_column :players, :deaths
  end

  def down
    add_column :players, :deaths, :string
    add_column :players, :kills, :string
  end
end
