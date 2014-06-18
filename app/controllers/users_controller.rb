class UsersController < ApplicationController
  include ApplicationHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @users = User.where(agency: my_agency).order('username asc').paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js { render 'shared/index.js.erb' }
      format.html
    end
  end

  def show
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js { render 'shared/new.js.erb' }
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'shared/new.js.erb' }
      format.html
    end
  end

  def create
    @user = User.new(user_params)
    @user.agency = my_agency
    @user.role_ids = params[:roles_of_user]
    respond_to do |format|
      if @user.save
        flash.now[:notice] = '成功添加用户.'
        format.js { 
          @users = User.where(agency: my_agency).order('username asc').paginate(page: params[:page], per_page: 10)
          render 'shared/index' 
        }
      else
        format.js { render 'new.js.erb' }
      end
    end
  end

  def update
    @user.role_ids = params[:roles_of_user]
    @user.for_updating = true
    respond_to do |format|
      if @user.update(user_params)
        format.js { 
          flash.now[:notice] = '用户信息更新成功.'
          @users = User.where(agency: my_agency).order('username asc').paginate(page: params[:page], per_page: 10)
          render 'shared/index.js.erb' 
        }
      else
        format.js { 
          params[:from] = "edit"
          render 'shared/new.js.erb' 
        }
      end
    end
  end

  def destroy
    if Behavior.where(recorder_id: @user.id).empty? && @user.announcements.empty? && @user.steps.empty?
      @user.roles.clear
      @user.destroy
      flash.now[:notice] = "用户 '#{@user.username}' 已删除."
    else
      flash.now[:alert] = "不可删除该用户: 存在该用户的关联数据：行为记录, 公文公告或审批步骤."
    end
    @users = User.where(agency: my_agency).order('username asc').paginate(page: params[:page], per_page: 10)
    render 'shared/index.js.erb' 
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :department_id)
    end
end