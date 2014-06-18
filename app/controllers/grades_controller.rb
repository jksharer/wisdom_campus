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
          flash.now[:notice] = 'Grade was successfully created.'
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
          flash.now[:notice] = 'Grade was successfully updated.'
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
    if @grade.iclasses.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are classes related to the grade, you should not delete it."
          @grades = Grade.where(agency: my_agency, graduated: false)
          render 'shared/link.js.erb'
        }
      end      
    else
      @grade.destroy
      respond_to do |format|
        format.js {
          flash.now[:alert] = "The grade was deleted successfully."
          @grades = Grade.where(agency: my_agency) 
          render 'shared/link.js.erb'
        }
      end  
    end
  end

  private
    def set_grade
      @grade = Grade.find(params[:id])
    end

    def grade_params
      params.require(:grade).permit(:name, :description)
    end
end