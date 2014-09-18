class IclassesController < ApplicationController
  include ApplicationHelper
  before_action :set_iclass, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @iclasses = Iclass.where(agency: my_agency).order('grade_id asc').paginate(page: params[:page], per_page: 10)  
    @grades = Grade.where(agency: my_agency).order('id asc')
  end

  def show
  end

  def new
    @iclass = Iclass.new
    @grades = Grade.where(agency: my_agency).order('id asc')
    render 'shared/new.js.erb'
  end

  def edit
    @grades = Grade.where(agency: my_agency).order('id asc')
    render 'shared/new.js.erb' 
  end

  def create
    @iclass = Iclass.new(iclass_params)
    @iclass.agency = current_user.agency
    respond_to do |format|
      if @iclass.save
        format.js {
          # 添加class report
          set_initial_data
          flash.now[:notice] = '班级创建成功.'
          render 'index.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @iclass.update(iclass_params)
        format.js {
          # 更新class report
          report = ClassReport.find_by(iclass: @iclass, semester: Semester.find_by(current: true))
          report.grade = @iclass.grade
          set_initial_data
          @total_classes = ClassReport.where(semester: Semester.find_by(current: true)).size  
          @total_students = ClassReport.where(semester: Semester.find_by(current: true)).pluck(:students).inject(:+)
          flash.now[:notice] = '班级信息更新成功.'
          render 'students/index.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @iclass.students.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = '该班级下面存在学生信息, 不可删除.'
          render 'shared/notice.js.erb'
        }
      end  
    else
      @iclass.destroy
      respond_to do |format|
        format.js {
          set_initial_data
          flash.now[:notice] = '班级删除成功.'
          render 'index.js.erb'
        }
      end  
    end
  end

  private
    def set_iclass
      @iclass = Iclass.find_by(id: params[:id], agency: my_agency)
    end

    def iclass_params
      params.require(:iclass).permit(:name, :grade_id, :header, :phone)
    end
end