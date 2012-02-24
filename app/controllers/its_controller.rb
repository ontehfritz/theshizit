class ItsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  
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
	   @recent_post = Content.all(:order => 'created_at DESC', :limit => 20)
	   @popular = Content.all(:order => 'click_count DESC', :limit => 20)
	   @categories = Category.find_all_by_it_id(@it.id)
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
end