class Comment < ActiveRecord::Base
  default_scope :conditions => ["comments.in_recycling = ?", false]
  validates :theshiz, :presence => true
	belongs_to :content, :counter_cache => true
end
