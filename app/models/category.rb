class Category < ActiveRecord::Base
	default_scope :conditions => ["categories.in_recycling = ?", false]
	validates :theshiz, :presence => true, :length => { :maximum => 20 }, :uniqueness => { :scope => :it_id,
    :message => "This category has already been created" }
	has_many :contents
	belongs_to :it, :counter_cache => true
	
	def to_param
		"#{id}-#{theshiz.gsub(/[^a-z0-9]+/i, '-')}"
	end
end
