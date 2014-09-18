class ReportsController < ApplicationController
  include ApplicationHelper
  before_action :authorize

  def home
    if params[:student_id]
      @student = Student.find(params[:student_id])
    end
  end

  def update_reports
    if params[:semester]
      semester = Semester.find(params[:semester])
    else
      semester = Semester.find_by(current: true)
    end
    initialize_reports(semester) if semester
    flash.now[:notice] = "该学期报表数据更新完成."
  end

  def via_classes
    if params[:semester]
      @semester = Semester.find(params[:semester])
    else
      @semester = Semester.find_by(current: true)
    end
    @reports = ClassReport.where(semester_id: @semester.id)
    @total_classes = @reports.size  
    @total_students = @reports.pluck(:students).inject(:+)
    @total_behaviors = @reports.pluck(:behaviors).inject(:+)
  	respond_to do |format|
  		format.js {
  			@view = 'via_classes'
  			render 'reports.js.erb'
  		}
  		format.html {
  			render '_print_via_classes', layout: 'print'
  		}
  	end
  end

  def via_grades
    if params[:semester]
      @semester = Semester.find(params[:semester])
    else
      @semester = Semester.find_by(current: true)
    end
    @grades = Grade.where(agency: my_agency, graduated: false)
    @reports = ClassReport.where(semester_id: @semester.id)
    @total_classes = @reports.size  
    @total_students = @reports.pluck(:students).inject(:+)
    @total_behaviors = @reports.pluck(:behaviors).inject(:+)
    respond_to do |format|
      format.js {
        @view = 'via_grades'
        render 'reports.js.erb'
      }
      format.html {
        render '_print_via_grades', layout: 'print'
      }
    end
  end

  def query
    @result_student = Student.find_by(agency: my_agency, sid: params[:student])
    if params[:query]  # 点击查找按钮         
      respond_to do |format|    
        format.js { render 'query.js.erb' }
      end
    else  # 点击提交按钮  
      if @result_student.nil?   # 未找到学生
        respond_to do |format|    
          format.js { render 'query.js.erb' }
        end    
      else    # 点击提交按钮，成功找到学生，开始生成报告
        @semester = Semester.find(params[:semester])
        @behaviors = Behavior.where(student_id: @result_student.id, 
          created_at: @semester.start_date.midnight..@semester.end_date.midnight).order("created_at asc")
        @total = 0
        @behaviors.map { |b| @total += b.score }
        @final_score = full_score + @total
        @rule = EstimateRule.where(agency: my_agency).where("lower <= ?", @final_score).where("higher >= ?", @final_score).first
        respond_to do |format|    
          format.js { 
            @view = 'estimate_report'
            render 'reports.js.erb' 
          }
          format.html {
            render '_print_estimate', layout: 'print'
          }
        end    
      end
    end  
  end
 
  def print_estimate
    @result_student = Student.find(params[:student_id])
    @semester = Semester.find(params[:semester_id])
    @behaviors = Behavior.where(student_id: @result_student.id, 
          created_at: @semester.start_date.midnight..@semester.end_date.midnight).order("created_at asc")
    @total = 0
    @behaviors.map { |b| @total += b.score }
    @final_score = full_score + @total
    puts "score: #{@final_score}"
    @rule = EstimateRule.where(agency: my_agency).where("lower <= ?", @final_score).where("higher >= ?", @final_score).first
    respond_to do |format|
      format.html {
        render '_print_estimate', layout: 'print'
      }
    end
  end

end