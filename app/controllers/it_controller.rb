class ItController < ApplicationController
	def index
	    @its = It.find(:all, :order => "created_at DESC")
	end
	
	def show
	   @it = params[:id].nil? ? It.where(:is_current => true).first : It.find(params[:id])
	   @categories = Category.find_all_by_it_id(@it.id)
	end
	
	def you
	  @it = params[:id].nil? ? It.where(:is_current => true).first : It.find(params[:id])
	  @categories = Category.find_all_by_user_id_and_it_id(current_user.id, @it.id).sort_by{|category| category.contents.count}
	  @contents = Content.joins(:category).where(:user_id => current_user.id, 
	             :categories => { :it_id => @it.id}).all.sort_by{|content| content.comments.count}
	  @contents.reverse!
	  @comments = Comment.joins(:content => [:category]).where(:user_id => current_user.id, 
	         :categories => {:it_id => @it.id}).all
	  
	  @commented_contents = Array.new
	  @comments.each do |comment|
	    @commented_contents << comment.content
	  end
	  
	  @commented_contents.uniq!
	  @shiz_score = @categories.count + @contents.count + (@comments.count / 5)
	end
end