class Blog < ActiveRecord::Base
  belongs_to :categorie, class_name: 'Category', foreign_key: 'category_id'
  belongs_to :user, class_name: 'User', foreign_key: 'author'
  validates :title, presence: true
  validates :content, presence: true
  validates :image, presence: true
  validates :category_id, presence: true

  mount_uploader :image, BlogImageUploader
end
