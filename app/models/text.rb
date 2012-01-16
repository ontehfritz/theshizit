class Text < Content
	validates :title, :presence => true
	validates :theshiz, :length => { :maximum => 1024 }, :presence => true
end