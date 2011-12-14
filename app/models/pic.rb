class Pic < Content
	validates :title, :presence => true
	validates :theshiz, :presence => true, :length => { :maximum => 256 }
	validates :file_name, :presence => true, :unless => :image_type
end