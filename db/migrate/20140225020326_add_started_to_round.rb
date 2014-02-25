class AddStartedToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :started, :boolean, :default => false
  end
end
