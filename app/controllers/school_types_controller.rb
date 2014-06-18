class SchoolTypesController < ApplicationController
  before_action :set_school_type, only: [:show, :edit, :update, :destroy]
  before_action :authorize
    
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
    render 'shared/new.js.erb'
  end

  def create
    @school_type = SchoolType.new(school_type_params)
    if @school_type.save
      @school_types = SchoolType.all     
      render 'shared/link.js.erb' 
    else
      render 'shared/new.js.erb'
    end
  end

  def update
    respond_to do |format|
      if @school_type.update(school_type_params)
        format.js { 
          @school_types = SchoolType.all     
          render 'shared/link.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @school_type.agencies.size > 0 
      flash.now[:alert] = "有机构/学校使用了该类型, 不可删除."
    else
      @school_type.destroy
      flash.now[:notice] = "删除成功."
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