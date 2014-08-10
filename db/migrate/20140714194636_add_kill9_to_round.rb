class AddKill9ToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :kill9, :boolean
    add_column :rounds, :kill9_start_time, :datetime
    add_column :rounds, :kill9_players, :text 
  end
end
