class ChangeStatusToActiveInAssignments < ActiveRecord::Migration
  def up
    add_column :assignments, :active, :boolean, :default => false
  end

  def down
    remove_column :assignments, :active
  end
end
