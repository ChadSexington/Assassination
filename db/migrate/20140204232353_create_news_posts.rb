class CreateNewsPosts < ActiveRecord::Migration
  def change
    create_table :news_posts do |t|
      t.text :title
      t.text :body
      t.string :author
      t.boolean :hidden

      t.timestamps
    end
  end
end
