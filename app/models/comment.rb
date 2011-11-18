class Comment < ActiveRecord::Base
    default_scope :conditions => ["in_recycling = ?", false]
    validates :theshiz, :presence => true
	belongs_to :content, :counter_cache => true
end
