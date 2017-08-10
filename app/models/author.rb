class Author < ActiveRecord::Base
  has_many :posts
  has_many :comments
  belongs_to :user

  validates :full_name, presence: true
end
