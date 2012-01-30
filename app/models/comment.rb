class Comment < ActiveRecord::Base
  default_scope :conditions => ["comments.in_recycling = ?", false]
  validates :theshiz, :presence => true
	belongs_to :content, :counter_cache => true
	after_save :update_counter_cache
  after_destroy :update_counter_cache
	
  def update_counter_cache
    self.content.active_comments_count = Comment.count( :conditions => ["in_recycling = 0 AND content_id = ?", self.content.id])
    self.content.save
  end
end
