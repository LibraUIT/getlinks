class CreateBlog < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.string :title
      t.string :image
      t.text :content
      t.boolean :status
      t.integer :author
    end
  end
end
