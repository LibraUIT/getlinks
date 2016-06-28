class AddDateToBlog < ActiveRecord::Migration
  def change
    add_column(:blogs, :created_at, :datetime)
    add_column(:blogs, :updated_at, :datetime)
  end
end
