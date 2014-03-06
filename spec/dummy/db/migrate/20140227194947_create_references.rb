class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.text :body

      t.timestamps
    end
  end
end
