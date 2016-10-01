class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :content, presence: true
  validates :email, presence: true
end
