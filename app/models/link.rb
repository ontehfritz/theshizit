class Link < Content
	validates :theshiz, :presence => true
	validates :title, :presence => true
	validates_format_of :theshiz, :with => URI::regexp(%w(http https))
end