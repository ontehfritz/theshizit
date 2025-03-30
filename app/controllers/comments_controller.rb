class CommentsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  #before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :only => [:delete, :update, :edit]
  
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
  		  format.html { render :layout => "application" }# new.html.erb
  		  format.json { render json: @comment }
  		end
  	end
  end
  
  # POST /comments
  # POST /comments.json
  def create
    it = It.find(params[:it_id])
  	if !it.locked
			@comment = Comment.new(comment_params)
  		@comment.theshiz = sanitize(@comment.theshiz)
  		@comment.user_id = 0
  		@comment.ip = request.remote_ip;
			latest_comment = Comment.where(content_id: @comment.content.id).order(created_at: :desc).first

  		if latest_comment != nil
  		  @comment.comment_number = latest_comment.comment_number + 1
  		end
  		
  		@it = it
      @category =  @comment.content.category
      @content =  @comment.content
      
      time_diff = Shizit::Application.config.comment_throttle + 1

			latest = Comment.where(ip: @comment.ip).order(created_at: :desc).first
      
      if latest != nil
        time_diff = Time.now - latest.created_at
      end
      
  		respond_to do |format|
  		  if time_diff > Shizit::Application.config.comment_throttle
    		  if @comment.save
    			  flash[:notice] = 'Comment was successfully created.'
    			  format.html { redirect_to it_category_content_url(@comment.content.category.it, @comment.content.category, @comment.content) }
    			  format.json { render json: @comment, status: :created, location: @comment }
    		  else
    			  format.html { render action: "new"}
    			  format.json { render json: @comment.errors, status: :unprocessable_entity }
    		  end
  		  else
  		    @comment.errors.add("theshiz", "Please wait: " + 
                (Shizit::Application.config.comment_throttle).to_s + " seconds. Before posting another comment.")
          format.html { render action: "new" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
  		  end
  		end
  	 end
  end
  
  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
  	@comment.in_recycling = true
     
    if (can? :delete, @comment)
    	if @comment.save
    		respond_to do |format|
    		  format.html { redirect_to it_category_content_url(@comment.content.category.it, 
    		    @comment.content.category, @comment.content) }
    		  format.json { head :ok }
    		end
    	end
  	end
	end

	private

	def comment_params
		params.require(:comment).permit(:content_id, :theshiz, :humanizer_answer, :humanizer_question_id)
	end
end
