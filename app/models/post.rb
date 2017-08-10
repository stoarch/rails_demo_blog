class Post < ActiveRecord::Base
  acts_as_taggable 

  has_many :comments
  belongs_to :author

  validates :title, presence: true, length: {minimum: 5, maximum: 50}
  validates :content, presence: true, length: {minimum: 50}
  validates :author_id, presence: true
  validates_inclusion_of :published, in: [true, false] 

  accepts_nested_attributes_for :comments, allow_destroy: true, reject_if: :all_blank

  SHORT_CONTENT_LENGTH = 100

  def short_content
    content[0..SHORT_CONTENT_LENGTH]
  end

  class << self
    def unpublished
      where(published: false)
    end

    def published
      where(published: true)
    end

    def all_published?
      where(nil).all?{|p| p.published }
    end
  end

  before_save :default_values

  def default_values
    self.published ||= false 
    true
  end

  def tags_list
    tags.map{|t| t.name }.join(',')
  end
end
