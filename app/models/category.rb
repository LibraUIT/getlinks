class Category < ActiveRecord::Base
  extend FriendlyId
  has_many :blogs, foreign_key: 'category_id', class_name: 'Blog', dependent: :destroy
  validates :name, presence: true

  scope :by_actived, -> () { where(status: true) }
  friendly_id :name, use: [:slugged, :finders]
end
