class AddRecordedToDeaths < ActiveRecord::Migration
  def change
    add_column :deaths, :recorded, :boolean, :default => true
  end
end
