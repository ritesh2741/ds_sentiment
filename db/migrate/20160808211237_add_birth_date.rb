class AddBirthDate < ActiveRecord::Migration
  def change
    add_column :posts, :dob, :string

  end
end
