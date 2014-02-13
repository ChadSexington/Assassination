class ChangeTargetToTargetIdInAssignments < ActiveRecord::Migration
  def change
    remove_column :assignments, :target, :string
    add_column :assignments, :target_id, :integer
  end
end
