class AddPartyUser < ActiveRecord::Migration[5.1]
  def change
      create_table :party_users do |t|
          t.integer :party_id
          t.integer :user_id

          t.timestamps
      end
  end
end
