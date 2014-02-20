class AddAutoEnrollToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :auto_enroll, :boolean, :default => true
  end
end
