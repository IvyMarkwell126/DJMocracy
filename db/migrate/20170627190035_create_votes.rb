class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true, null: false
      t.references :party_song, foreign_key: true, null: false
      
      t.timestamps
    end
    add_index :votes, [:user_id, :party_song_id], unique: true
  end
end
