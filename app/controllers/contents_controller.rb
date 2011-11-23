class ContentsController < ApplicationController
include ActionView::Helpers::SanitizeHelper
  before_filter :authenticate_user!, :except => [:show, :pic]
  load_and_authorize_resource :only => [:delete, :update, :edit]
  # GET /contents
  # GET /contents.json
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
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    it = It.find(params[:it_id])
	if it.is_current
		@content = Content.new
		@content.category = Category.find(params[:category_id])
		@content.category.it = it;
		
		respond_to do |format|
		  format.html  {render :layout => "dialog"}# new.html.erb
		  format.json { render json: @content }
		end
	end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.json
  def create
    it = It.find(params[:it_id])
	  if it.is_current
		  @content = params[:content][:type].constantize.new(params[:content])
		  @content.title = strip_tags(@content.title)
		  @content.theshiz = sanitize(@content.theshiz)
		  @content.user_id = current_user.id

		  respond_to do |format|
		    if @content.save
		       Subscription.create(:user_id => current_user.id, :type_name => @content.category.class.name, :type_id => @content.category.id)
		       Subscription.create(:user_id => current_user.id, :type_name => @content.class.name, :type_id => @content.id)
		       Subscription.delay.notify(@content)
		       Subscription.delay.notify(@content.category)
		       
			     flash[:notice] = 'Content was successfully created.'
			     format.html { render action: "close", :layout => "dialog" }
			     format.json { render json: @content, status: :created, location: @content }
		    else
			     format.html { render action: "new", :layout => "dialog" }
			     format.json { render json: @content.errors, status: :unprocessable_entity }
		    end
		  end
	   end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
	@content.in_recycling = true
    #@content.destroy

    respond_to do |format|
		if @content.save
		  format.html { redirect_to it_category_url(@content.category.it, @content.category) }
		  format.json { head :ok }
		end
    end
  end
  
  def pic
	@content = Content.find(params[:id])

    @image = @content.image_data
    send_data @image, :type => @content.image_type, 
        :filename => @content.file_name, :disposition => 'inline'
  end
end
