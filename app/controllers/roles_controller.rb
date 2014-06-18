class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @roles = Role.where(agency: my_agency)
    respond_to do |format|
      format.js { render 'shared/index' }
      format.html
    end
  end

  def show
  end

  def new
    @role = Role.new
    @one_level_menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    respond_to do |format|
      format.js { render 'shared/new' }
      format.html
    end
  end

  def edit
    @one_level_menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    respond_to do |format|
      format.js { render 'shared/new' }
      format.html
    end
  end

  def create
    @role = Role.new(role_params)
    @role.menu_ids = params[:menus_of_role]
    @role.agency = my_agency
    respond_to do |format|
      if @role.save
        format.js {
          flash.now[:notice] = '角色创建成功.'
          @roles = Role.all
          render 'shared/index'     
        }
      else
        format.js {
          @one_level_menus = Menu.where(parent_menu_id: nil).order('display_order asc')  
          render 'shared/new'
        }
      end
    end
  end

  def update
    @role.menu_ids = params[:menus_of_role]
    respond_to do |format|
      if @role.update(role_params)
        format.js {
          flash.now[:notice] = '成功更新角色信息.'
          @roles = Role.all
          render 'shared/index'  
        }
      else
        format.js {
          @one_level_menus = Menu.where(parent_menu_id: nil).order('display_order asc')  
          render 'shared/new'
        }
      end
    end
  end

  def destroy
    if @role.users.size > 0
      flash.now[:alert] = "存在使用该角色的用户, 建议不要删除."  
      render 'shared/notice_heavy'
    else
      @role.menus.clear
      @role.destroy  
      flash.now[:notice] = "角色 '#{@role.name}' 已删除."
      @roles = Role.all
      render 'index.js.erb'
    end
  end

  private
    def set_role
      @role = Role.find(params[:id])   # 此处改成find_by(id: params[:id], agency: my_agency) 会造成未知的异常！请注意！
    end

    def role_params
      params.require(:role).permit(:name)
    end
end