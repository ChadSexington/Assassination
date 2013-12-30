class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :player_id
      t.string :target
      t.integer :status
      t.text :elim_location

      t.timestamps
    end
  end
end
