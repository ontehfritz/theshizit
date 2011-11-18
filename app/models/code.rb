class Code < Content
	validates :theshiz, :length => { :maximum => 150 }, :presence => true, :format => { :with => /gist.github.com|pastie.org/,
    :message => "Only urls from Github Gist and Pastie are allowed: 
					Example: https://gist.github.com/1370294.js?file=gistfile1.coffee
					Example: http://pastie.org/2872802.js" }
end