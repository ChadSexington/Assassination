class AddRoundIdToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :round_id, :int
  end
end
