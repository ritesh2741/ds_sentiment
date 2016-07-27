class AddSentimentsCountToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :pos_sentiment1, :integer
  	add_column :posts, :neg_sentiment1, :integer
  	add_column :posts, :ntr_sentiment1, :integer
  	add_column :posts, :pos_sentiment2, :integer
  	add_column :posts, :neg_sentiment2, :integer
  	add_column :posts, :ntr_sentiment2, :integer
  end
end
