class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def home
    set_initial_data
    @students = Student.order('sid asc')
    respond_to do |format|
      format.js { render 'index.js.erb' }
      format.html 
    end
  end

  # 通过年级和班级获取学生
  def index
    if !params[:grade].nil?
      iclasses = Iclass.where(agency_id: my_agency.id, grade_id: params[:grade])
      @students = []
      iclasses.each do |c|
        c.students.each do |s|
          @students << s       
        end
      end
    elsif !params[:iclass_id].nil?
      @students = Student.where(iclass_id: params[:iclass_id]).order('sid asc')  
    end
    set_initial_data
    respond_to do |format|
      format.js { render 'students.js.erb' }
      format.html 
    end    
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html 
    end    
  end

  def create
    @student = Student.new(student_params)
    @student.class_role_ids = params[:class_roles]
    @student.agency = my_agency
    respond_to do |format|
      if @student.save
        format.js {
          flash.now[:notice] = 'Student was successfully created.'
          set_initial_data
          render 'index.js.erb'
        }
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @student.class_role_ids = params[:class_roles]
    respond_to do |format|
      if @student.update(student_params)
        format.js {
          flash.now[:notice] = 'Student was successfully updated.'
          set_initial_data
          render 'index.js.erb'
        }
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @student.class_roles.clear unless @student.class_roles.empty?
    @student.destroy
    respond_to do |format|
      format.js {
        flash.now[:notice] = 'Student was successfully deleted.'
        set_initial_data
        @students = Student.where(iclass_id: @student.iclass_id).order('sid asc')  
        render 'students.js.erb'
      }
      format.html { redirect_to students_url }
    end
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:sid, :name, :gender, :photo_url, :iclass_id)
    end
end