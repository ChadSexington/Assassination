class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :irc_nick
      t.text :notes

      t.timestamps
    end
  end
end
