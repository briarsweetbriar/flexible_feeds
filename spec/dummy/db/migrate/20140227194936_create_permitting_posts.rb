class CreatePermittingPosts < ActiveRecord::Migration
  def change
    create_table :permitting_posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
