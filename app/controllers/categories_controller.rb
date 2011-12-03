class CategoriesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :only => [:delete, :update, :edit]
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @sort = params[:sort].nil? ? "pop" : params[:sort]
    @category = Category.find(params[:id])
    
    if current_user != nil
      Notification.delete_all(["user_id = ? and type_id = ? and type_name = ?", current_user.id, @category.id, @category.class.name])
    end
    page = params[:page].nil? ? 1 : params[:page]
	  if @sort == "recent"
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('created_at DESC')
	  else
		  #@contents = Content.find_all_by_category_id(params[:id], :order => "comments_count DESC")
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('vote DESC')
	  end
	 
	  if(current_user != nil)
	     content_ids = @contents.map {|c| c.id}
       @notifications = Notification.find(:all,:conditions => ["type_id in (?) and user_id = ?", content_ids, current_user.id])
    end
    
	  @it = It.where(:is_current => true).first
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
	it = It.find(params[:it_id])
	if it.is_current
		@category = Category.new
		@category.it = It.where(:is_current => true).first
		

		respond_to do |format|
		  format.html  {render :layout => "dialog"}# new.html.erb
		  format.json { render json: @category }
		end
	end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
	it = It.find(params[:it_id])
	if it.is_current
		@category = Category.new(params[:category])
		@category.it = It.where(:is_current => true).first
		@category.user_id = current_user.id
		
		respond_to do |format|
		  if @category.save
			flash[:notice] = 'Category was successfully created.'
			format.html { render action: "close",:layout => "dialog" }
			format.json { render json: @category, status: :created, location: @category }
		  else
			format.html { render action: "new", layout: "dialog" }
			format.json { render json: @category.errors, status: :unprocessable_entity }
		  end
		end
	end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
	@category.in_recycling = true
    #@category.destroy

	if @category.save
		respond_to do |format|
		  format.html { redirect_to "/" }
		  format.json { head :ok }
		end
	end
  end
end
