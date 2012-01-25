class ItsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def new 
    @new_it = It.new 
    @it = It.where(:is_default => true).first
    if (can? :create, @comment)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @new_it }
      end
    end
  end
  
  def create
    @new_it = It.new(params[:it])
    if (can? :create, @new_it)
      respond_to do |format|
        if @new_it.save
          flash[:notice] = 'It was successfully created.'
          if @new_it.is_default
            @its = It.find(:all)
            @its.each do |t|
              if t.id != @new_it.id
                t.is_default = false
                t.save
              end
            end
          end
          
          format.html { redirect_to its_path, notice: 'It was successfully created.' }
          format.json { render json: @new_it, status: :created, location: @new_it }
        else
          format.html { render action: "new" }
          format.json { render json: @new_it.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
	def index
	    @it = It.where(:is_default => true).first
	    @its = It.find(:all, :order => "created_at DESC")
	end
	
	def show
	   @it = params[:id].nil? ? It.where(:is_default => true).first : It.find(params[:id])
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
	
	def edit
	   @new_it = It.find(params[:id])
	   @it = It.where(:is_default => true).first
	end
	
	def update
	  @new_it = It.find(params[:id])
	  if (can? :update, @new_it)
  	  respond_to do |format|
        if @new_it.update_attributes(params[:it])
          if @new_it.is_default
            @its = It.find(:all)
            @its.each do |t|
              if t.id != @new_it.id
                t.is_default = false
                t.save
              end
            end
          end
          
          format.html { redirect_to its_path, notice: 'It was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @new_it.errors, status: :unprocessable_entity }
        end
      end
	  end
	end

	
	
	def you
	  @it = params[:id].nil? ? It.where(:is_default => true).first : It.find(params[:id])
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