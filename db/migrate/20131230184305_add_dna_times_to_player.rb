class AddDnaTimesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :dna_times, :text
  end
end
