class Category < ActiveRecord::Base
  include Humanizer
  require_human_on :create
	default_scope :conditions => ["categories.in_recycling = ?", false]
	validates :theshiz, :presence => true, :length => { :maximum => 20 }, :uniqueness => { :scope => :it_id,
    :message => "This category has already been created" }
	has_many :contents
	belongs_to :it, :counter_cache => true
	validate :category_count_within_limit, :on => :create

  def category_count_within_limit
    if self.it.categories(:reload).count >= 200
      errors.add(:base, "Exceeded category limit, only 200 Categories per board")
    end
  end
	
	def to_param
		"#{id}-#{theshiz.gsub(/[^a-z0-9]+/i, '-')}"
	end
	
	def get_total_points
	  total = self.contents.count
	  
	  self.contents.each do |content|
	    total += content.comments.count / 4
	  end
	  
	  total
	end
end
