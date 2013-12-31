class AddConfirmationCodeToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :confirmation_code, :string
  end
end
