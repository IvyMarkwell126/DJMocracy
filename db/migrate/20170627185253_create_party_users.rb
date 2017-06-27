class CreatePartyUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :party_users do |t|
      t.references :party, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :party_users, [:party_id, :user_id], unique: true
  end
end
