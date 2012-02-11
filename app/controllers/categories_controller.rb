class CategoriesController < ApplicationController
  #before_filter :authenticate_user!, :except => [:show, :create]
  load_and_authorize_resource :only => [:delete, :update]
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
    
    page = params[:page].nil? ? 1 : params[:page]
	  if @sort == "recent"
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('created_at DESC')
	  else
		  #@contents = Content.find_all_by_category_id(params[:id], :order => "comments_count DESC")
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('active_comments_count DESC')
	  end
    
	  @it = @category.it
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
  	it = It.find(params[:it_id])
  	if !it.locked
  		@category = Category.new
  		@category.it = it
  		
  		respond_to do |format|
  		  format.html  {render :layout => "dialog"}# new.html.erb
  		  format.json { render json: @category }
  		end
  	end
  end

  # GET /categories/1/edit
  # def edit
    # @category = Category.find(params[:id])
  # end

  # POST /categories
  # POST /categories.json
  def create
  	it = It.find(params[:it_id])
  	if !it.locked
  		@category = Category.new(params[:category])
  		@category.it = it
  		@category.user_id = 0
  		@category.ip = request.remote_ip;
  		
  		time_diff = 2
  		
  	  latest = Category.find(:first,:conditions => ['ip = ?', @category.ip], :order => 'created_at DESC', :limit => 1)
  	  
  	  if latest != nil
  	    time_diff = Time.now - latest.created_at
  	  end
  		
  		respond_to do |format|
  		  if time_diff > 600
      		if @category.save
      			flash[:notice] = 'Category was successfully created.'
      			format.html { render action: "close",:layout => "dialog" }
      			format.json { render json: @category, status: :created, location: @category }
      		else
      			format.html { render action: "new", layout: "dialog" }
      			format.json { render json: @category.errors, status: :unprocessable_entity }
      		end
    		else
    		  format.html { render action: "flood", layout: "dialog" }
    		end
    	end
  	 end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  # def update
    # @category = Category.find(params[:id])
# 
    # respond_to do |format|
      # if @category.update_attributes(params[:category])
        # format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        # format.json { head :ok }
      # else
        # format.html { render action: "edit" }
        # format.json { render json: @category.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    if (can? :delete, @category)
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
end
