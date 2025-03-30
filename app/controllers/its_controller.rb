class ItsController < ApplicationController
  before_action :authenticate_user!, :except => [:show, :activity]
  
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
      @its = It.order(created_at: :desc)
	end

  def show
    @view = params[:view].nil? ? "category" : params[:view]
    @it = params[:id].nil? ? It.where(:is_default => true).first : It.find(params[:id])
    @recent_post = Content.order('created_at DESC').limit(20)
    @popular_post = Content.order('click_count DESC').limit(20)
    @popular = @popular_post  # <- added this line for your view
    if @view == "posts"
      @posts = Content.includes(:category)
                      .joins(:category)
                      .where("categories.in_recycling = ? and categories.it_id = ?", false, @it.id)
    else
      @categories = Category.where(it_id: @it.id)
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
	
	def activity
    @recent_post = Content.order('created_at DESC').limit(20)
    @popular_post = Content.order('click_count DESC').limit(20)
    @recent_categories = Category.order('created_at DESC').limit(20)
    @popular_categories = Category.order('click_count DESC').limit(20)
    @recent_comments = Comment.order('created_at DESC').limit(20)
    @category_count = Category.count
    @post_count = Content.count
    @comment_count = Comment.count
	end
end