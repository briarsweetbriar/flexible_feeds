class CreateFlexibleFeedsFeeds < ActiveRecord::Migration
  def change
    create_table :flexible_feeds_feeds do |t|
      t.string :feedable_type
      t.integer :feedable_id
      t.string :name

      t.timestamps
    end

    add_index :flexible_feeds_feeds, :name
    add_index :flexible_feeds_feeds,
      [:feedable_id, :feedable_type],
      name: "flexible_feeds_feeds_on_parent"
  end
end
