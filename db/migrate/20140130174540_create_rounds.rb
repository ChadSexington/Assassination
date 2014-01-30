class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean  :active
      t.text     :players

      t.timestamps
    end
  end
end
