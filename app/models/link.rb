class Link < Content
	validates :theshiz, :presence => true
	validates :title, :presence => true
	validates_format_of :theshiz, :with => URI::regexp(%w(http https))
	
	def is_youtube
	  if self.theshiz.include? "www.youtube.com"
	    true
	  elsif self.theshiz.include? "youtu.be"
	    true
	  else
	    false
	  end
	end
	
	def youtube_id
	  tube_id = nil
  	if self.theshiz[/youtu\.be\/([^\?]*)/]
      tube_id = $1
    else
      self.theshiz[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      tube_id = $5
    end
    
    tube_id
	end
	
end