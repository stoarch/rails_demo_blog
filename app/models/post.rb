class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author

  validates :title, presence: true, length: {minimum: 5, maximum: 50}
  validates :content, presence: true, length: {minimum: 50}
  validates :author_id, presence: true

  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :all_blank

  SHORT_CONTENT_LENGTH = 100

  def short_content
    content[0..SHORT_CONTENT_LENGTH]
  end

end
