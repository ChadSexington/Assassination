class ChangeStatusToActiveInAssignments < ActiveRecord::Migration
  def change
    remove_column :assignments, :status
    add_column :assignments, :active, :boolean, :default => false
  end
end
