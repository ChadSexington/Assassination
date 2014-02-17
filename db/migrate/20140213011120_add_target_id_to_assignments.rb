class AddTargetIdToAssignments < ActiveRecord::Migration
  def up
    add_column :assignments, :target_id, :integer
  end
  
  def down
    remove_column :assignments, :target_id
  end
end
