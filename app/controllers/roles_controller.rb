class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @roles = Role.all
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
  end

  def new
    @role = Role.new
    @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @role = Role.new(role_params)
    @role.menu_ids = params[:menus_of_role]
    respond_to do |format|
      if @role.save
        format.js {
          flash.now[:notice] = 'Role was successfully created.'
          @roles = Role.all     
        }
        format.html { redirect_to roles_url, 
          notice: 'Role was successfully created.' }
      else
        format.js {
          @menus = Menu.where(parent_menu_id: nil).order('display_order asc')  
        }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    @role.menu_ids = params[:menus_of_role]
    respond_to do |format|
      if @role.update(role_params)
        format.js {
          flash.now[:notice] = 'Role was successfully updated.'
          @roles = Role.all
          render 'create'  
        }
        format.html { redirect_to roles_url, 
          notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.js {
          @menus = Menu.where(parent_menu_id: nil).order('display_order asc')  
          render 'create'
        }
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, 
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role.menus.clear
    @role.users.clear
    @role.destroy
    respond_to do |format|
      format.js {
        flash.now[:notice] = "the role #{@role.name} has been deleted."
        @roles = Role.all
      }
      format.html { redirect_to roles_url }
      format.json { head :no_content }
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:name)
    end
end