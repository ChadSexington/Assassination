class AddLivePlayerIdsToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :live_player_ids, :text
  end
end
