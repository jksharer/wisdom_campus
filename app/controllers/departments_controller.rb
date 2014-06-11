# 本控制器暂时只接受js请求，无法回应html请求
class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @departments = Department.where(agency: my_agency).order('name asc')
    render 'shared/index.js.erb'
  end

  def show
    render 'shared/new.js.erb'
  end

  def new
    @department = Department.new
    render 'shared/new.js.erb' 
  end

  def edit
    render 'shared/new.js.erb' 
  end

  def create
    @department = Department.new(department_params)
    @department.agency = current_user.agency
    if @department.save
      flash.now[:notice] = 'Department was successfully created.'
      @departments = Department.where(agency: my_agency).order('name asc')
      render 'shared/index.js.erb'
    else
      render 'shared/new.js.erb'
    end
  end

  def update
    if @department.update(department_params)
      flash.now[:notice] = 'Department was successfully updated.'
      @departments = Department.where(agency: my_agency).order('name asc')
      render 'shared/index.js.erb'  
    else
      render 'shared/new.js.erb'
    end
  end

  # 只接受ajax方式操作
  def destroy
    if @department.sub_departments.empty?
      @department.destroy
      flash.now[:notice] = 'Department was successfully deleted.'
    else
      flash.now[:alert] = "The department has sub departments, you just can't delete it."
    end
    @departments = Department.where(agency: my_agency).order('name asc')
    render 'shared/index.js.erb'
    
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