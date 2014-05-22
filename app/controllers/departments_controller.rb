class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @departments = Department.order('name asc')
  end

  def show
    
  end

  def new
    @department = Department.new
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
    @department = Department.new(department_params)
    @department.agency = current_user.agency
    
    respond_to do |format|
      if @department.save
        format.js { 
          @departments = Department.order('name asc')     
          flash.now[:notice] = 'Department was successfully created.'
          render 'index.js.erb'
        }
        format.html { redirect_to departments_url, 
          notice: 'Department was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.js { 
          @departments = Department.order('name asc')     
          flash.now[:notice] = 'Department was successfully updated.'
          render 'index.js.erb'  
        }
        format.html { redirect_to departments_url, 
          notice: 'Department was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit', layout: 'empty' }
      end
    end
  end

  def destroy
    if @department.sub_departments.empty?
      @department.destroy
      respond_to do |format|
        format.js {
          @departments = Department.order('name asc')     
          flash.now[:notice] = 'Department was successfully deleted.'
          render 'index.js.erb'    
        }
        format.html { redirect_to departments_url }
      end  
    else
      respond_to do |format|
        format.js {
          flash.now[:alert] = "The department has sub departments, you just can't delete it."
          @departments = Department.order('name asc')
          render 'index.js.erb'
        }
        format.html {
          redirect_to departments_url, 
            notice: "The department has sub departments, you just can't delete it."    
        }
      end
    end
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end

    # 获取前端参数的正确方式是: params[:department][:parent_department]，
    # 因为前端使用了form_for以及f.select这种标签
    def department_params
      params.require(:department).permit(:name, :description, :parent_department_id)
    end
end