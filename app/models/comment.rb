class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :author

  validates :content, presence: true, length: {minimum:10,maximum:1000}
  validates :author_id, presence: true
  validates :post_id, presence: true
end
