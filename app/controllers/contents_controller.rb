class ContentsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  before_filter :authenticate_user!, :except => [:show, :pic]
  load_and_authorize_resource :only => [:delete, :update,:create]
  # GET /contents
  # GET /contents.json
  def vote
    @content = Content.find(params[:id])
    if VoteLog.has_user_voted(current_user, @content)
      @content.vote.nil? ? @content.vote = 0 : @content.vote -= 1
      VoteLog.delete_all(["user_id = ? and type_id = ? and type_name = ?", current_user.id, @content.id, @content.class.name])
    else
      @content.vote.nil? ? @content.vote = 1 : @content.vote += 1
      VoteLog.create(:user_id => current_user.id, :type_name => @content.class.name, :type_id => @content.id) 
    end
    @content.save
    #redirect_to it_category_url(@content.category.it, @content.category)
    redirect_to(:back) 
  end
  
  def index
    @contents = Content.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
    @it = @content.category.it
    
    if current_user != nil
      Notification.delete_all(["user_id = ? and type_id = ? and type_name = ?", current_user.id, @content.id, @content.class.name])
      comment_ids = @content.comments.map {|c| c.id}
      @notifications = Notification.find(:all,:conditions => ["type_id in (?) and user_id = ? and type_name = 'Comment'", comment_ids, current_user.id])
    end
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    it = It.find(params[:it_id])
	  if !it.locked
  		@content = Content.new
  		@content.category = Category.find(params[:category_id])
  		@content.category.it = it;
  		@it = @content.category.it
		
  		respond_to do |format|
  		  format.html 
  		  format.json { render json: @content }
  		end
	  end
  end

  # GET /contents/1/edit
  # def edit
    # @content = Content.find(params[:id])
  # end

  # POST /contents
  # POST /contents.json
  def create
    it = It.find(params[:it_id])
	  if !it.locked
		  @content = params[:content][:type].constantize.new(params[:content])
		  @content.title = strip_tags(@content.title)
		  @content.theshiz = sanitize(@content.theshiz)
		  @content.user_id = current_user.id
		  @it = @content.category.it

		  respond_to do |format|
		    if @content.save
		       Subscription.find_or_create_by_user_id_and_type_name_and_type_id(current_user.id, 
		              @content.category.class.name, @content.category.id)
		       Subscription.find_or_create_by_user_id_and_type_name_and_type_id(current_user.id, 
		              @content.class.name, @content.id)
		       Subscription.delay.notify(@content, current_user)
		       Subscription.delay.notify(@content.category, current_user)
		       
			     flash[:notice] = 'Content was successfully created.'
			     format.html { redirect_to it_category_url(@content.category.it, @content.category) }
			     format.json { render json: @content, status: :created, location: @content }
		    else
			     format.html { render action: "new"}
			     format.json { render json: @content.errors, status: :unprocessable_entity }
		    end
		  end
	   end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  # def update
    # @content = Content.find(params[:id])
# 
    # respond_to do |format|
      # if @content.update_attributes(params[:content])
        # format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        # format.json { head :ok }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @content.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
	  @content.in_recycling = true
    #@content.destroy

    respond_to do |format|
      if (can? :delete, @content) || current_user.id == @content.user_id
  		  if @content.save
  		    format.html { redirect_to it_category_url(@content.category.it, @content.category) }
  		    format.json { head :ok }
  		  end
		  end
    end
  end
  
  def pic
	  @content = Content.find(params[:id])
    @image = @content.image_data
    send_data @image, :type => @content.file_type, 
        :filename => @content.file_name, :disposition => 'inline'
  end
end
