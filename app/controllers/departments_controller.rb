# 本控制器暂时只接受js请求，无法回应html请求
class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    if params[:query] == "one_level"
      @departments = Department.where(agency: my_agency, parent_department: nil).order('name asc').
        paginate(page: params[:page], per_page: 10)
    else
      @departments = Department.where(agency: my_agency).order('name asc').
        paginate(page: params[:page], per_page: 10)
    end
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
      flash.now[:notice] = '部门创建成功.'
      @departments = Department.where(agency: my_agency).order('name asc')
      render 'shared/index.js.erb'
    else
      render 'shared/new.js.erb'
    end
  end

  def update
    if @department.update(department_params)
      flash.now[:notice] = '部门信息更新成功.'
      @departments = Department.where(agency: my_agency).order('name asc')
      render 'shared/index.js.erb'  
    else
      render 'shared/new.js.erb'
    end
  end

  # 只接受ajax方式操作
  def destroy
    if @department.users.size > 0  
      flash.now[:alert] = "该部门下面存在员工/用户, 请不要删除."
    elsif @department.sub_departments.size > 0 
      flash.now[:alert] = "该部门存在子部门, 请不要删除."
    else
      @department.destroy
      flash.now[:notice] = '成功删除部门.'
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