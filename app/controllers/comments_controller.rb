class CommentsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :only => [:delete, :update, :edit]
  # GET /comments
  # GET /comments.json
  
  def vote
    @comment = Comment.find(params[:comment_id])
    if VoteLog.has_user_voted(current_user, @comment)
      @comment.vote.nil? ? @comment.vote = 0 : @comment.vote -= 1
      VoteLog.delete_all(["user_id = ? and type_id = ? and type_name = ?", current_user.id, @comment.id, @comment.class.name])
      @comment.save
    else
      @comment.vote.nil? ? @comment.vote = 1 : @comment.vote += 1
      VoteLog.create(:user_id => current_user.id, :type_name => @comment.class.name, :type_id => @comment.id) 
      @comment.save
    end
    
    redirect_to it_category_content_url(@comment.content.category.it, @comment.content.category, @comment.content)
  end
  
  
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
  	it = It.find(params[:it_id])
  	if !it.locked
  		@comment = Comment.new
  		@it = it
  		@category = Category.find(params[:category_id])
  		@content = Content.find(params[:content_id])
  		@comment.content_id = params[:content_id]
  		
  		respond_to do |format|
  		  format.html { render :layout => "dialog" }# new.html.erb
  		  format.json { render json: @comment }
  		end
  	end
  end

  # GET /comments/1/edit
  #def edit
  #  @comment = Comment.find(params[:id])
  #end

  # POST /comments
  # POST /comments.json
  def create
    it = It.find(params[:it_id])
  	if !it.locked
  		@comment = Comment.new(params[:comment])
  		@comment.theshiz = sanitize(@comment.theshiz)
  		@comment.user_id = current_user.id
  		
  		@it = it
      @category =  @comment.content.category
      @content =  @comment.content
      
  		respond_to do |format|
  		  if @comment.save
  		    Subscription.find_or_create_by_user_id_and_type_name_and_type_id(current_user.id, 
  		                                              @comment.content.category.class.name, @comment.content.category)
          Subscription.find_or_create_by_user_id_and_type_name_and_type_id(current_user.id, 
                                                    @comment.content.class.name,  @comment.content.id)
          Subscription.find_or_create_by_user_id_and_type_name_and_type_id(current_user.id, 
                                                    @comment.content.category.class.name, @comment.content.category.id)
          Subscription.delay.notify(@comment, current_user)
          Subscription.delay.notify(@comment.content, current_user)
          Subscription.delay.notify(@comment.content.category, current_user)
  			  flash[:notice] = 'Comment was successfully created.'
  			#render :js => "$(parent.document).find('.ui-dialog');window.parent.$('#divId').dialog('close');"
  			  format.html { render action: "close", :layout => "dialog"}
  			  format.json { render json: @comment, status: :created, location: @comment }
  		  else
  			  format.html { render action: "new", :layout => "dialog"}
  			  format.json { render json: @comment.errors, status: :unprocessable_entity }
  		  end
  		end
  	 end
  end
  # PUT /comments/1
  # PUT /comments/1.json
  # def update
    # @comment = Comment.find(params[:id])
# 
    # respond_to do |format|
      # if @comment.update_attributes(params[:comment])
        # format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        # format.json { head :ok }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @comment.errors, status: :unprocessable_entity }
      # end
    # end
  # end
  
  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
  	@comment.in_recycling = true
      #@comment.destroy
    if (can? :delete, @comment) || (current_user.id == @comment.user_id)
    	if @comment.save
    		respond_to do |format|
    		  format.html { redirect_to it_category_content_url(@comment.content.category.it, @comment.content.category, @comment.content) }
    		  format.json { head :ok }
    		end
    	end
  	end
  end
end
