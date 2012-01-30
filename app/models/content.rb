class Content < ActiveRecord::Base
  default_scope :conditions => ["contents.in_recycling = ?", false]
	has_many :comments
	belongs_to :category, :counter_cache => true
	after_save :update_counter_cache
	after_destroy :update_counter_cache
	self.per_page = 10
	
	def self.inherited(child)
		child.instance_eval do
			def model_name
				Content.model_name
			end
		end
		super
	end
	
	def came_from
	  self.name
	end
	
	def image_file=(input_data)
		self.file_name = input_data.original_filename
		self.file_type = input_data.content_type.chomp
		self.image_data = input_data.read
	end
	
	def to_param
		"#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
	end
	

  def update_counter_cache
    self.category.active_contents_count = Content.count( :conditions => ["in_recycling = 0 AND category_id = ?", self.category.id])
    self.category.save
  end
end
