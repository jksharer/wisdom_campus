class GradesController < ApplicationController
  before_action :set_grade, only: [:show, :edit, :update, :destroy, :graduate]
  before_action :authorize

  def index
    if params[:graduated] == 'false'
      @grades = Grade.where(agency: my_agency, graduated: false)
    else
      @grades = Grade.where(agency: my_agency, graduated: true)
    end
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @grade = Grade.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  def create
    @grade = Grade.new(grade_params)
    @grade.agency = my_agency
    respond_to do |format|
      if @grade.save
        format.js {
          @grades = Grade.where(agency: my_agency, graduated: false)
          flash.now[:notice] = '年级添加成功.'
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }  
      end
    end
  end

  def update
    respond_to do |format|
      if @grade.update(grade_params)
        format.js {
          @grades = Grade.where(agency: my_agency, graduated: false)
          flash.now[:notice] = '更新成功.'
          render 'shared/link.js.erb'     
        }  
      else
        format.js { render 'shared/new.js.erb' }  
      end
    end
  end

  def graduate
    @grade.update_attribute(:graduated, true)
    @grade.iclasses.each do |iclass|
      iclass.students.each do |student|
        student.update_attribute(:graduated, true)
      end
    end
    flash.now[:notice] = "已成功将#{@grade.name}#{@grade.total_students_count}个学生设为已毕业状态."
    @grades = Grade.where(agency: my_agency, graduated: true)
    render 'shared/link.js.erb'
  end

  def destroy
    flash.now[:alert] = "年级信息不可删除, 您可以把该年级的状态置为已毕业."
    @grades = Grade.where(agency: my_agency, graduated: false)
    render 'shared/link.js.erb'
  end

  private
    def set_grade
      @grade = Grade.find(params[:id])
    end

    def grade_params
      params.require(:grade).permit(:name, :description)
    end
end