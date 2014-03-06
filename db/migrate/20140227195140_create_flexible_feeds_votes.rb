class CreateFlexibleFeedsVotes < ActiveRecord::Migration
  def change
    create_table :flexible_feeds_votes do |t|
      t.integer :event_id
      t.integer :voter_id
      t.string :voter_type
      t.integer :value, null: false, default: 0

      t.timestamps
    end

    add_index :flexible_feeds_votes, :event_id
    add_index :flexible_feeds_votes,
      [:voter_id, :voter_type],
      name: "flexible_feeds_votes_on_voter"
  end
end
