class AddEnrollInNextToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :enroll_in_next, :boolean
  end
end
