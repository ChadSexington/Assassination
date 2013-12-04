class AddAuthenticationVariablesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :hashed_password, :string
    add_column :players, :salt, :string
  end
end
