class AddSentimentstoComments < ActiveRecord::Migration
  def change
		add_column :comments, :sentiment1, :string
  	add_column :comments, :sentiment2, :string
  end
end
