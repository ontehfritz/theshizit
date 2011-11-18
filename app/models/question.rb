class Question < Content
	 validates :theshiz, :length => { :maximum => 150 }, :presence => true
end