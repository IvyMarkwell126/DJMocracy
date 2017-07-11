class DefaultVotes < ActiveRecord::Migration[5.1]
  def change
      change_table :party_songs do |t|
        t.change :votes, :integer, :default => 1
      end
  end
end
