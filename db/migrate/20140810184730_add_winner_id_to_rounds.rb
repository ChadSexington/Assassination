class AddWinnerIdToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :winner_id, :integer
  end
end
