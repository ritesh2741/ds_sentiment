class RenamePostColumn < ActiveRecord::Migration
  def change
    rename_column :posts, :text, :fb_id
  end
end
