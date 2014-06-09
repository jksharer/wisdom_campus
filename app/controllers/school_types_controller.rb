class SchoolTypesController < ApplicationController
  before_action :set_school_type, only: [:show, :edit, :update, :destroy]
  
  def index
    @school_types = SchoolType.all
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @school_type = SchoolType.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @school_type = SchoolType.new(school_type_params)

    respond_to do |format|
      if @school_type.save
        format.js { 
          @school_types = SchoolType.all     
          flash.now[:notice] = "Agency type was successfully created."
          render 'index.js.erb' 
        }
        format.html { redirect_to @school_type, notice: 'School type was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @school_type.update(school_type_params)
        format.js { 
          @school_types = SchoolType.all     
          flash.now[:notice] = "Agency type was successfully updated."
          render 'index.js.erb' 
        }
        format.html { redirect_to @school_type, notice: 'School type was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if @school_type.agencies.size > 0 
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are agencies related to this, you should not delete id."
          render 'index.js.erb'
        }
        format.html { redirect_to school_types_url }  
      end
    else
      @school_type.destroy  
      format.js {
          flash.now[:notice] = "the type was deleted successfully."
          render 'index.js.erb'
        }
        format.html { redirect_to school_types_url }
    end
  end
  
  private
    def set_school_type
      @school_type = SchoolType.find(params[:id])
    end

    def school_type_params
      params.require(:school_type).permit(:name, :description)
    end
end