class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @agencies = Agency.order('name asc').page(params[:page]).per_page(5)
  end

  def show
    
  end

  def new
    @agency = Agency.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @agency = Agency.new(agency_params)
    respond_to do |format|
      if @agency.save
        format.js { 
          flash.now[:notice] = 'Agency was successfully created.'
          @agencies = Agency.order('name asc').page(params[:page]).per_page(5)     
          render 'index.js.erb' 
        }
        format.html { redirect_to agencies_path, 
          notice: 'Agency was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new', layout: 'empty' }
      end
    end
  end

  def update
    respond_to do |format|
      if @agency.update(agency_params)
        format.js { 
          flash.now[:notice] = 'Agency was successfully updated.'
          @agencies = Agency.order('name asc').page(params[:page]).per_page(5)     
          render 'index.js.erb' 
        }
        format.html { redirect_to agencies_path, 
          notice: 'Agency was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    # 不允许删除机构
    respond_to do |format|
      format.js {
        flash.now[:notice] = "The rule is anyone CAN'T destroy Agency."
      }
      format.html { redirect_to agencies_url, 
        notice: "The rule is anyone CAN'T destroy Agency." }
    end
  end

  private
    def set_agency
      @agency = Agency.find(params[:id])
    end

    def agency_params
      params.require(:agency).permit(:name, :description)
    end
end