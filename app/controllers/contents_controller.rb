class ContentsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  #before_filter :authenticate_user!, :except => [:show, :pic]
  load_and_authorize_resource :only => [:delete, :update]

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
    @it = @content.category.it
    @content.update_click_counter
    
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

  # POST /contents
  # POST /contents.json
  def create
    it = It.find(params[:it_id])
	  if !it.locked
			@content = params[:content][:type].constantize.new(content_params)
		  @content.title = strip_tags(@content.title)
		  @content.theshiz = sanitize(@content.theshiz)
		  @content.user_id = 0
		  @content.ip = request.remote_ip;
		  @it = @content.category.it
		  
		  time_diff = Shizit::Application.config.content_throttle + 1

			latest = Content.where(ip: @content.ip, in_recycling: false).order(created_at: :desc).first
      
      if latest != nil
        time_diff = Time.now - latest.created_at
      end
      

		  respond_to do |format|
		    if time_diff > Shizit::Application.config.content_throttle
  		    if @content.save
  			     flash[:notice] = 'Content was successfully created.'
  			     format.html { redirect_to it_category_url(@content.category.it, @content.category) }
  			     format.json { render json: @content, status: :created, location: @content }
  		    else
  			     format.html { render action: "new"}
  			     format.json { render json: @content.errors, status: :unprocessable_entity }
  		    end
		    else
		      @content.errors.add("theshiz", "Please wait: " + 
                (Shizit::Application.config.content_throttle).to_s + " seconds. Before posting another.")
          format.html { render action: "new" }
          format.json { render json: @content.errors, status: :unprocessable_entity }
		    end
		  end
	   end
  end
  
  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
	  @content.in_recycling = true
    
    respond_to do |format|
      if (can? :delete, @content)
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

	private

	def content_params
		params.require(:content).permit(
			:category_id,
			:type,
			:title,
			:file_type,
			:file_name,
			:theshiz,
			:humanizer_answer,
			:humanizer_question_id,
			:image_file
		)
	end
end
