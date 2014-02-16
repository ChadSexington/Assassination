class AddTargetIdToAssignments < ActiveRecord::Migration
  def up
    remove_column :assignments, :target
  end
  
  def down
    add_column :assignments, :target, :integer
  end
end
