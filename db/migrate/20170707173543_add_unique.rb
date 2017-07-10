class AddUnique < ActiveRecord::Migration[5.1]
  def change
  	add_index :songs, [:title, :artist], unique: true
  end
end
