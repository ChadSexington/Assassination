class AddNoDisplayToKills < ActiveRecord::Migration
  def change
    add_column :kills, :no_display, :boolean, :default => false
  end
end
