class Code < Content
	validates :theshiz, :length => { :maximum => 2056 }, :presence => true
	validates :title, :presence => true
	
	def symbol
	  "{01}"
	end
end