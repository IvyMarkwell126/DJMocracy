class CreatePartySongs < ActiveRecord::Migration[5.1]
  def change
    create_table :party_songs do |t|
      t.integer :party_id
      t.integer :song_id
      t.integer :votes

      t.timestamps
    end
  end
end
