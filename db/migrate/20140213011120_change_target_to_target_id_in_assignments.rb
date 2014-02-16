class ChangeTargetToTargetIdInAssignments < ActiveRecord::Migration
  def up
    remove_column :assignments, :target
    add_column :assignments, :target_id, :integer
  end
  
  def down
    remove_column :assignments, :target_id
    add_column :assignments, :target
  end
end
