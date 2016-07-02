class AddSlugToSomeTable < ActiveRecord::Migration
  def change
    add_column :blogs, :slug, :string
    add_column :categories, :slug, :string
    add_column :users, :slug, :string
  end
end
