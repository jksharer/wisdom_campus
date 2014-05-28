#encoding: UTF-8
class MainPagesController < ApplicationController
  include ApplicationHelper
  before_action :authorize

  def home
    # 取出最新8条已审批发布的公告
    @announcements = Announcement.where(workflow_state: "accepted").order('created_at DESC').limit(8)

    # 待审批公告
    @being_reviews = needed_my_review("Announcement")
    
    # 最近5条违反秩序行为记录
    @behaviors = Behavior.where(agency: my_agency).order('created_at DESC').paginate(page: params[:page], per_page: 5)

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
  		flash.now[:alert] = "the length of password must be greater than 6."
  		respond_to do |format|
        format.js { render 'change_password.js.erb' }
        format.html
      end 
  	elsif password != password_confirmation
  		flash.now[:alert] = "the password does not equal confirmation."
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
      flash.now[:notice] = "the password was successfully updated."
      respond_to do |format|
        format.js { render 'my.js.erb' }
        format.html { redirect_to my_path }
      end
  	end
  end
end