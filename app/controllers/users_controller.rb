class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @users = User.all
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
        flash.now[:notice] = 'User was successfully created.'
        format.js { 
          @users = User.all
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
          flash.now[:notice] = 'User was successfully updated.'
          @users = User.all
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
    @user.roles.clear
    @user.destroy
    respond_to do |format|
      format.js {  
        @users = User.all
        flash.now[:notice] = "User '#{@user.username}' deleted successfully."
        render 'shared/index.js.erb' 
      }
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