class ItController < ApplicationController
	def index
	    @its = It.find(:all, :order => "created_at DESC")
	end
	
	def show
	   @it = params[:id].nil? ? It.where(:is_current => true).first : It.find(params[:id])
	   @categories = Category.find_all_by_it_id(@it.id)
	end
end
