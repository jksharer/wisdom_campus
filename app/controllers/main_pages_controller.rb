#encoding: UTF-8
class MainPagesController < ApplicationController
  include ApplicationHelper
  before_action :authorize

  def home
    # 首次登陆系统进入Home界面时，对菜单进行初始化
    unless params[:parent]
      @current_menu = current_user.one_level_menus.first
      @two_level_menus = current_user.sub_menus(@current_menu)  
    end
    reports = ClassReport.where(semester: Semester.find_by(current: true))
    @total_classes = reports.size  
    @total_students = reports.pluck(:students).inject(:+)
    @total_behaviors = reports.pluck(:behaviors).inject(:+) 

    @current_semester = Semester.find_by(current: true) 
    # 计算人次
    @student_times = Behavior.where(created_at: @current_semester.start_date..@current_semester.end_date, 
                                    confirm_state: 2, 
                                    agency: my_agency)
                                    .select(:student_id).distinct.size
    # 每种类型的记录次数
    @type_counts = []
    types = BehaviorType.all
    types.each do |type|
      count = Behavior.where(created_at: @current_semester.start_date..@current_semester.end_date, 
                            confirm_state: 2,
                            behavior_type: type, 
                            agency: my_agency).size
      @type_counts << [type.name, count]
    end

    # 取出最新8条已审批发布的公告
    @announcements = Announcement.where(workflow_state: "accepted").order('created_at DESC').limit(8)

    # 待审批公告
    @being_reviews = needed_my_review("Announcement")
    
    # 最近8条违反秩序行为记录
    @behaviors = Behavior.where(agency: my_agency, confirm_state: 2).order('created_at DESC').paginate(page: params[:page], per_page: 8)

    respond_to do |format|
      format.js          
      format.html
      format.html.phone    
      format.html.tablet   
    end
  end

  def about
  end

  def my
  	@current_user = current_user
    respond_to do |format|
      format.js
      format.html
    end
  end

  def change_password
  	@current_user = current_user
  end

  def update_password
  	password = params[:password]
  	password_confirmation = params[:password_confirmation]			
  	if password.nil? || password.length < 6
  		flash.now[:alert] = "密码长度须在6位以上."
  		respond_to do |format|
        format.js { render 'change_password.js.erb' }
        format.html
      end 
  	elsif password != password_confirmation
  		flash.now[:alert] = '密码及密码确认不匹配.'
  		respond_to do |format|
        format.js { render 'change_password.js.erb' }
        format.html { redirect_to change_password_path }
      end
    else 
      user = current_user
      user.password = password
      user.password_confirmation = password_confirmation
      user.for_updating = true
      user.save!
      flash.now[:notice] = '密码修改成功.'
      respond_to do |format|
        format.js { render 'my.js.erb' }
        format.html { redirect_to my_path }
      end
  	end
  end
end