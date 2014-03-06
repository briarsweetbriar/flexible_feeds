class CreateFlexibleFeedsEvents < ActiveRecord::Migration
  def change
    create_table :flexible_feeds_events do |t|
      t.string :eventable_type
      t.integer :eventable_id
      t.integer :creator_id
      t.string :creator_type

      t.integer :parent_id
      t.string :parent_type
      t.integer :ancestor_id
      t.string :ancestor_type
      t.integer :children_count, null: false, default: 0
      
      t.integer :votes_sum, null: false, default: 0
      t.integer :votes_for, null: false, default: 0
      t.integer :votes_against, null: false, default: 0
      t.float :controversy, null: false, default: 0, precision: 5, scale: 2
      t.float :popularity, null: false, default: 0, precision: 5, scale: 2

      t.timestamps
    end

    add_index :flexible_feeds_events, :votes_sum
    add_index :flexible_feeds_events, :votes_for
    add_index :flexible_feeds_events, :votes_against
    add_index :flexible_feeds_events, :controversy
    add_index :flexible_feeds_events, :popularity
    add_index :flexible_feeds_events, :children_count
    add_index :flexible_feeds_events,
      [:eventable_id, :eventable_type],
      name: "flexible_feeds_events_on_eventable"
    add_index :flexible_feeds_events,
      [:creator_id, :creator_type],
      name: "flexible_feeds_events_on_creator"
    add_index :flexible_feeds_events,
      [:parent_id, :parent_type],
      name: "flexible_feeds_events_on_parent"
    add_index :flexible_feeds_events,
      [:ancestor_id, :ancestor_type],
      name: "flexible_feeds_events_on_ancestor"
  end
end
