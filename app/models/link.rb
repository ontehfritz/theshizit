require "oembed"

class Link < Content
	validates :theshiz, :presence => true
	validates :title, :presence => true
	validates_format_of :theshiz, :with => URI::regexp(%w(http https))
	
	def render_html
	  html = ""
	  begin
	   OEmbed::Providers.register_all
	   #OEmbed::Providers.register(OEmbed::Providers::SoundCloud)
	   resource = OEmbed::Providers.get(self.theshiz)
	   return html = resource.html.gsub('feature=oembed','wmode=transparent')   
	  rescue
	   html = ""
	  end
	  html
	end
	
	def symbol
	  "URL"
	end
	
end