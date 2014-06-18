class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @agencies = Agency.order('name asc')
    render 'shared/index.js.erb'
  end

  def show
    
  end

  def new
    @agency = Agency.new
    respond_to do |format|
      format.js { render 'shared/new.js.erb' }
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'shared/new.js.erb' }
    end
  end

  def create
    @agency = Agency.new(agency_params)
    respond_to do |format|
      if @agency.save
        format.js { 
          flash.now[:notice] = '成功新增学校.'
          @agencies = Agency.order('name asc')     
          render 'shared/index.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @agency.update(agency_params)
        format.js { 
          flash.now[:notice] = '学校信息更新成功'
          @agencies = Agency.order('name asc')     
          render 'shared/index.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    # 不允许删除机构
    respond_to do |format|
      format.js {
        flash.now[:alert] = "为了数据的安全性不允许删除机构/学校."
        @agencies = Agency.order('name asc')     
        render 'shared/index.js.erb' 
      }
    end
  end

  private
    def set_agency
      @agency = Agency.find(params[:id])
    end

    def agency_params
      params.require(:agency).permit(:name, :school_type_id, :header, :address, :description)
    end
end