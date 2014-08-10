class AddRecordedToKills < ActiveRecord::Migration
  def change
    add_column :kills, :recorded, :boolean, :default => true
  end
end
