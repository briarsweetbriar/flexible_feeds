class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.text :body

      t.timestamps
    end
  end
end
