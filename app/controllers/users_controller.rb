class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @users = User.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @user = User.new(user_params)
    @user.agency = current_user.agency
    @user.role_ids = params[:roles_of_user]
    respond_to do |format|
      if @user.save
        flash.now[:notice] = 'User was successfully created.'
        format.js { 
          @users = User.all
          render 'index' 
        }
        format.html { redirect_to users_url }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @user.role_ids = params[:roles_of_user]
    @user.for_updating = true
    respond_to do |format|
      if @user.update(user_params)
        format.js { 
          flash.now[:notice] = 'User was successfully updated.'
          @users = User.all
          render 'index.js.erb' 
        }
        format.html { redirect_to users_url, 
          notice: 'User was successfully updated.' }
      else
        format.js { 
          params[:from] = "edit"
          render 'new.js.erb' 
        }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @user.roles.clear
    @user.destroy
    respond_to do |format|
      format.js {  
        @users = User.all
        flash.now[:notice] = "User '#{@user.username}' deleted successfully."
        render 'index.js.erb' 
      }
      format.html { redirect_to users_url }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :department_id)
    end
end