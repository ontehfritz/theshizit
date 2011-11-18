class It < ActiveRecord::Base
	has_many :categories, :dependent => :destroy
	
	def to_param
		"#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
	end
end
