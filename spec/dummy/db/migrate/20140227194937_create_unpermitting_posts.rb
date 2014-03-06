class CreateUnpermittingPosts < ActiveRecord::Migration
  def change
    create_table :unpermitting_posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
