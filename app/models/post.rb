class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author

  validates :title, presence: true, length: {minimum: 5, maximum: 50}
  validates :content, presence: true, length: {minimum: 50}
  validates :author_id, presence: true
end
