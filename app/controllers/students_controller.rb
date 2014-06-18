class StudentsController < ApplicationController
  include SessionsHelper
  before_action :set_student, only: [:show, :edit, :update, :destroy, :graduate]
  before_action :authorize

  def home
    set_initial_data
    respond_to do |format|
      format.js { render 'index.js.erb' }
      format.html 
    end
  end

  def download
    send_file "public/download/#{params[:filename]}.#{params[:extension]}" unless params[:filename].blank?    
  end

  def import_export 
    respond_to do |format|
      format.js {
        flash.now[:notice] = "注意事项：支持excel(.xls/.xlsx)及CSV文件格式, 文件内容须按照文件模板整理数据，
          其中年级、班级、姓名、学号等四个属性不能为空."
      }
      format.html {
        render '_import_export.html.erb'
      }
    end
  end

  def import
    if params[:file]
      @agency = my_agency
      array = Student.import(params[:file], @agency)
      # @count = Student.import(params[:file], @agency).first
      if array.first >= 0
        respond_to do |format|
          format.html {
            redirect_to import_export_students_path, notice: "成功导入#{array.first}个学生的基础数据, 
              其中新增#{array.last}个, 更新#{array.first - array.last}个."
          }
        end  
      else
        respond_to do |format|
          format.html {
            redirect_to import_export_students_path, alert: "导入失败: 年级、班级、姓名、学号信息不能为空,请仔细检查并改正."
          }
        end  
      end
    else
      respond_to do |format|
        format.html {
          redirect_to import_export_students_path, alert: "请选择文件，支持.xls、.xlsx及csv格式."
        }
      end
    end
  end

  def export 
    @students = []
    if params[:grade].nil? || params[:grade] == ""   # 导出所有学生
      grades = Grade.where(agency: my_agency).order('name asc')
      grades.each do |grade|
        grade.iclasses.each do |iclass|
          @students.concat(iclass.students)
        end
      end
    else                     # 导出选定年级学生
      Grade.find(params[:grade]).iclasses.each do |iclass|
        @students.concat(iclass.students)
      end
    end
    respond_to do |format|
      format.html {
        redirect_to '/export_students.xls'
      }
      format.xls
    end
  end

  # 通过班级获取学生
  def index
    if params[:iclass_id]
      @students = Student.where(iclass_id: params[:iclass_id]).order('sid asc').
        paginate(page: params[:page], per_page: 12)  
    else 
        
    end
    respond_to do |format|
      format.js { render 'students.js.erb' }
      format.html 
    end    
  end

  def show
  end

  def new
    @student = Student.new
    @iclasses = my_agency.iclasses
    render 'shared/new.js.erb'
  end

  def edit
    @iclasses = my_agency.iclasses
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
        flash.now[:notice] = '成功添加学生信息.'
        format.js {
          @from = 'create'
          render 'show.js.erb'
        }
        format.html { redirect_to @student }
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
        flash.now[:notice] = '学生信息更新成功.'
        format.js { render 'show.js.erb' }
        format.html { redirect_to @student }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def graduate
    if params[:graduated] == 'true'
      @student.update_attribute(:graduated, true)
    else
      @student.update_attribute(:graduated, false)
    end
    flash.now[:notice] = "已成功设置该学生的毕业状态."    
    render 'show.js.erb'
  end

  def destroy
    flash.now[:notice] = 'Student was successfully deleted.'
    set_initial_data
    @students = Student.where(iclass_id: params[:iclass_id]).order('sid asc').
      paginate(page: params[:page], per_page: 12)    
    render 'students.js.erb'
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:sid, :name, :gender, :photo, :iclass_id)
    end
end