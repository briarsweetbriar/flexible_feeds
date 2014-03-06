class CreateFlexibleFeedsFollows < ActiveRecord::Migration
  def change
    create_table :flexible_feeds_follows do |t|
      t.integer :feed_id
      t.integer :follower_id
      t.string :follower_type

      t.timestamps
    end

    add_index :flexible_feeds_follows, :feed_id
    add_index :flexible_feeds_follows,
      [:follower_id, :follower_type],
      name: "flexible_feeds_follows_on_follower"
  end
end
