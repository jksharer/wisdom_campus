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
    render 'shared/new.js.erb'
  end

  def edit
    respond_to do |format|
      format.js { render 'shared/new.js.erb' }
    end
  end

  def create
    @school_type = SchoolType.new(school_type_params)

    respond_to do |format|
      if @school_type.save
        format.js { 
          flash.now[:notice] = "Agency type was successfully created."
          @school_types = SchoolType.all     
          render 'shared/link.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @school_type.update(school_type_params)
        format.js { 
          @school_types = SchoolType.all     
          flash.now[:notice] = "Agency type was successfully updated."
          render 'shared/link.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @school_type.agencies.size > 0 
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are agencies related to this, you should not delete id."
        }
      end
    else
      @school_type.destroy
      flash.now[:notice] = "the type was deleted successfully."
    end
    @school_types = SchoolType.all     
    render 'shared/link.js.erb'
  end
  
  private
    def set_school_type
      @school_type = SchoolType.find(params[:id])
    end

    def school_type_params
      params.require(:school_type).permit(:name, :description)
    end
end