class CreateKills < ActiveRecord::Migration
  def change
    create_table :kills do |t|
      t.integer :player_id
      t.integer :deceased_id
      t.text :recap
      t.text :location

      t.timestamps
    end
  end
end
