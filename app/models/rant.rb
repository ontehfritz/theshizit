class Rant < Content
	validates :theshiz, :length => { :maximum => 512 }, :presence => true
	validates :title, :presence => true
end