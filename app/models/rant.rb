class Rant < Content
	validates :theshiz, :length => { :maximum => 1024 }, :presence => true
	validates :title, :presence => true
end