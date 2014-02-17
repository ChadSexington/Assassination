class RenameHiddenToPublicInNewsPosts < ActiveRecord::Migration
  def change
    rename_column :news_posts, :hidden, :public
  end
end
