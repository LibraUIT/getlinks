class Blog < ActiveRecord::Base
  belongs_to :categories
  validates :title, presence: true
  validates :content, presence: true
  validates :image, presence: true
  validates :category_id, presence: true

  mount_uploader :image, BlogImageUploader
end
