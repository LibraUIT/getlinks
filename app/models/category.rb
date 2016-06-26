class Category < ActiveRecord::Base
  has_many :blogs, dependent: :destroy
  validates :name, presence: true

  scope :by_actived, -> () { where(status: true) }
end
