class CreateFlexibleFeedsModeratorJoins < ActiveRecord::Migration
  def change
    create_table :flexible_feeds_moderator_joins do |t|
      t.integer :feed_id
      t.integer :moderator_id
      t.string :moderator_type

      t.timestamps
    end

    add_index :flexible_feeds_moderator_joins, :feed_id
    add_index :flexible_feeds_moderator_joins,
      [:moderator_id, :moderator_type],
      name: "flexible_feeds_moderator_joins_on_moderator"
  end
end
