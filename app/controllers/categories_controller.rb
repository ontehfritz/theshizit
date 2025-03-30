class CategoriesController < ApplicationController
  #before_filter :authenticate_user!, :except => [:show, :create]
  load_and_authorize_resource :only => [:delete, :update]
 
  # GET /categories/1
  # GET /categories/1.json
  def show
    @sort = params[:sort].nil? ? "pop" : params[:sort]
    @category = Category.find(params[:id])
    @category.update_click_counter
    
    page = params[:page].nil? ? 1 : params[:page]
    
	  if @sort == "recent"
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('created_at DESC')
	  else
		  @contents = Content.where(:category_id => params[:id]).paginate(:page => page).order('active_comments_count DESC')
	  end
    #application layout page needs this
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
  		  format.html  {render :layout => "application"}# new.html.erb
  		  format.json { render json: @category }
  		end
  	end
  end

  # POST /categories
  # POST /categories.json
	def create
		it = It.find(params[:it_id])
		if !it.locked
			@category = Category.new(category_params)
			@category.it = it
			@category.user_id = 0
			@category.ip = request.remote_ip

			time_diff = Shizit::Application.config.category_throttle + 1
			latest = Category.where(ip: @category.ip).order('created_at DESC').limit(1).first

			time_diff = Time.now - latest.created_at if latest.present?

			respond_to do |format|
				if time_diff > Shizit::Application.config.category_throttle
					if @category.save
						flash[:notice] = 'Category was successfully created.'
						format.html { redirect_to it_url(@category.it) }
						format.json { render json: @category, status: :created, location: @category }
					else
						format.html { render action: "new" }
						format.json { render json: @category.errors, status: :unprocessable_entity }
					end
				else
					@category.errors.add(:theshiz, "Please wait: #{Shizit::Application.config.category_throttle} seconds before creating another category.")
					format.html { render action: "new" }
					format.json { render json: @category.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    
    if (can? :delete, @category)
  	  @category.in_recycling = true
  
  	  if @category.save
  		  respond_to do |format|
  		    format.html { redirect_to "/" }
  		    format.json { head :ok }
  		  end
  	  end
	  end
	end

	private

	def category_params
		params.require(:category).permit(:theshiz, :is_nsfw, :humanizer_answer, :humanizer_question_id)
	end
end
