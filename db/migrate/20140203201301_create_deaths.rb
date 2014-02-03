class CreateDeaths < ActiveRecord::Migration
  def change
    create_table :deaths do |t|
      t.integer :player_id
      t.string :assassin_id
      t.text :recap
      t.text :location

      t.timestamps
    end
  end
end
