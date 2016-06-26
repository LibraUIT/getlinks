class Category < ActiveRecord::Base
  has_many :blogs, foreign_key: 'category_id', class_name: 'Blog', dependent: :destroy
  validates :name, presence: true

  scope :by_actived, -> () { where(status: true) }
end
