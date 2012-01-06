class ItController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
	def index
	    @it = It.where(:is_current => true).first
	    @its = It.find(:all, :order => "created_at DESC")
	end
	
	def show
	   @it = params[:id].nil? ? It.where(:is_current => true).first : It.find(params[:id])
	   @categories = Category.find_all_by_it_id(@it.id)
	   if(current_user != nil)
	     @notifications = Notification.where(:user_id => current_user.id, :type_name => "Category").all
	     if @notifications != nil
  	     @notifications.each do |notification|
  	       seek = Notification.find_all_by_user_id_and_parent_type_id(current_user.id, notification.type_id)
  	       if seek.empty?
  	         Notification.delete(notification.id)
  	       end
  	     end
	     end
	     
	     @notifications = Notification.where(:user_id => current_user.id, :type_name => "Category").all
	     
	   end
	end
	
	def you
	  @it = params[:id].nil? ? It.where(:is_current => true).first : It.find(params[:id])
	  @categories = Category.find_all_by_user_id_and_it_id(current_user.id, @it.id).sort_by{|category| category.contents.count}
	  @contents = Content.joins(:category).where(:user_id => current_user.id, 
	             :categories => { :it_id => @it.id, :in_recycling => false}).all.sort_by{|content| content.comments.count}
	  @contents.reverse!
	  @comments = Comment.joins(:content => [:category]).where(:user_id => current_user.id,
	         :contents => {:in_recycling => false} ,:categories => {:it_id => @it.id, :in_recycling => false}).all
	  
	  @commented_contents = Array.new
	  @comments.each do |comment|
	    @commented_contents << comment.content
	  end
	  
	  @commented_contents.uniq!
	  @shiz_score = @categories.count + @contents.count + (@comments.count / 5)
	end
end