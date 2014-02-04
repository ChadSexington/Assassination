class AddNicknameToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :nickname, :string
  end
end
