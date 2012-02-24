class Question < Content
  include ActionView::Helpers::TextHelper
	validates :theshiz, :length => { :maximum => 150 }, :presence => true
	 
	def title
	  truncate(self.theshiz, :length => 50, :ommission => "...")
  end
  
  def symbol
     "?"
  end
end